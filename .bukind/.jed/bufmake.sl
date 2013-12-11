% Autoupdate buffer routines.
% Usage:
%    bm_update_buffer("*mybuf*", "file1,../file2,/home/foo/bar.txt", &Time, parser);
%    (parser is a function reference, if not null, is called for every file
%    loaded, with the file name as parameter).
%
% These routines are intended for use by other scripts, so I don't autoload these.
%
implements("BufMake");

% Check if any of files has been modified.
static define bm_files_changed(FileList, Time)
{
        variable s;

        foreach (strchop(FileList, ',', 0)) {
                s = stat_file(());
                if (s != NULL) {
                        if (s.st_mtime > @Time)
                                return 1;
                }
        }
        return 0;
}

% Insert a file to current buffer.
static define bm_insert_file(fname, parser)
{
        variable fdir;

        fname = expand_filename(fname);
        flush("bufmake: rebuilding buffer ("+fname+")...");
        eob();
        push_mark();
        if (insert_file(fname) >= 0) {
		if (parser != NULL) {
                        narrow();
                        bob();
			@parser(fname);
                        widen();
                }
                pop_mark(0);
                return 0;
        } else {
                pop_mark(1);
                return -1;
        }
}

% Check if buffer needs update, and do it.
public define bm_update_buffer(Buffer, FileList, Time, parser)
{
        variable redo = 1;

        if (bufferp(Buffer)) {
                if (@Time != 0)
                        redo = bm_files_changed(FileList, Time);

                if (redo)
                        delbuf(Buffer);
        }

        setbuf(Buffer);
        if (redo) {
                flush("bufmake: rebuilding buffer...");
                foreach (strchop(FileList, ',', 0))
                        () = bm_insert_file((), parser);
                @Time = _time();
                message("bufmake: rebuilding buffer... Done.");
                set_buffer_modified_flag(0);
                set_readonly(1);
                bury_buffer(Buffer);
        }
}

static variable BG_Pid = -1;
static variable BG_Buffer = NULL;

% Support for background buffer loading...
public define bm_signal_handler(pid, flags, status)
{
        BG_Pid = -1;
        flush("bufmake: background building... Done.");
        set_buffer_modified_flag(0);
        set_readonly(1);
        bury_buffer(whatbuf());
}

% This uses a clever hack to build buffer in background.
% Works only on unix (uses cat and sh))!
public define bm_background_open(Buffer, FileList, Time)
{
        variable cmd = "";
        variable file;
        variable redo = 1;
        variable oldbuf = whatbuf();

        if (bufferp(Buffer)) {
                if (Time != 0)
                        redo = bm_files_changed(FileList, Time);

                if (redo)
                        delbuf(Buffer);
        }
        !if (redo) {
                setbuf(oldbuf);
                return;
        }

        foreach (strchop(FileList, ',', 0)) {
                file = expand_filename(());
                cmd = cmd + "cat " + file + " 2>/dev/null" + "; ";
        }

        setbuf(Buffer);
        BG_Pid = open_process ("sh" ,"-c", cmd, 2);
        if (BG_Pid < 0)
                error ("bufmake: Unable to start subprocess.");
        @Time = _time();

        set_process(BG_Pid, "signal", "bm_signal_handler");
        set_process(BG_Pid, "output", "@");

        setbuf(oldbuf);
        flush("bufmake: background building...");
}

provide("bufmake");
