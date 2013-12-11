% ntags.sl       -*- mode: SLang; mode: fold -*-
% read a tags file produced by ctags/etags programs
%
%_debug_info = 1;
%_traceback = 1;

implements("NTags");

require("ntags_walk");
require("wordsrch");
require("bufmake");

% What is in this file? %{{{
% a New Ctags reading engine for JED.
% Started as a modified version of standard ctags.sl.
% Written From Scratch By Saurus
% (Dino Leonardo Sangoi <g1001863@univ.trieste.it>).
%
% +++ Why this is better than old ctags ?
% 1) Support multiple tag files (Set Tags_Files to a colon-separated list of
%    tag files)
% 2) Support for more than 1 occurrence of same tag (subsequent calls to
%    ntags_next_tag() will cicle trough all the occurences. Note that
%    find_tag() will call automagically ntags_next_tag() if you look for the
%    last tag again on the same line).
% 3) Keeps a stack of positions visited, so you can navigate c source files
%    a bit like lynx. (this is really done by walk.sl)
% 4) Does a better work trying to found the right destination (is less confused
%    by prototypes), or at least I hope so !
% 5) Uses, if available, the extended flag written by Exhuberant ctags (the
%    default ctags program found in most Linux distributions). This allows to
%    prefer function bodies instead of prototypes, searching for static
%    functions only in the same file, and other clever things.
% 6) Some extra funny functions to play with (intellijed, intellijed_insert,
%    intellipointer, whatis) (in cfun.sl)
% 7) Far more customisable, see below for a list of user options.
% 8) Automatic reloading of modified tag files.
%
% --- Why this is worse of old ctags ?
% 1) Doesn't support emacs style tags. (I don't use it, but should be easy to
%    add).
% 2) May be a bit slower and uses more memory.

% User Defined Options:
% Tags_Files            : A Colon Separated list of tags files.
%                         (default = "tags")
% NTags_Follow_Now      : If the tag under the cursor exists, follow it without
%                         asking the user.
% NTags_Never_Ask       : Don't Ask if Tag Doesn't exists.
% NTags_Look_From_End   : Some Brain-damaged ctags Do not put the entire line
%                         on tag file, So the search algorithm may be fooled
%                         by function prototypes. This can also happen if the
%                         function and the prototype are written as:
%                         int a_function( int firstarg,
%                                         int secondarg)
%                         As the prototype almost surely is declared before
%                         the function, looking from end may help to find
%                         what we are looking for.
% NTags_Case_Sensitive  : -1 : Use Default (CASE_SEARCH). else set to 0 or 1.
% NTags_Save_Pos_On_Next: A stupid option, when enabled saves the position on
%                         walk stack even on ntags_next_tag().
% NTags_Add_Path_To_Tag:  Add full path to files in tag. This slows down a lot
%                         the tag files loading (is far better to use the -p
%                         option of some ctags).
%}}}

% User-definable variables %{{{

% This seems like a hack to me, why isn't done by site.sl ? Anyways I use the
% same method used by cmode.sl...
% autoload ("c_top_of_function", "cmisc");

custom_variable("Tags_Files",              "tags");
custom_variable("NTags_Follow_Now",       1);
custom_variable("NTags_Never_Ask",        1);
custom_variable("NTags_Look_From_End",    1);
custom_variable("NTags_Case_Sensitive",   1);
custom_variable("NTags_Save_Pos_On_Next", 0);
custom_variable("NTags_Add_Path_To_Tag",  0);
custom_variable("NTags_Prepend_Dir", NULL);

% Use these values if you perfer the old behavior, change also
% Walk_Use_Current_Window (from walk.sl)
% Tags_Files             = "tags";
% NTags_Follow_Now       = 0;
% NTags_Never_Ask        = 0;
% NTags_Look_From_End    = 1;
% NTags_Case_Sensitive   = 1;
% NTags_Save_Pos_On_Next = 0;
% NTags_Add_Path_To_Tag  = 0;
%}}}

% Static variables %{{{
static variable NTagsBuffer = "*tags*";
static variable NTagsBufferTime = 0;
static variable NTagsOldTag = "";
static variable NTagsOldFile = "";
static variable NTagsOldPos = 0;
%}}}

% "Low Level" Tag retrieving functions %{{{
% Get the tag under cursor, and ask user if configured to.
define get_tag()
{
        get_word();    % Leave on stack

        if (NTags_Follow_Now == 0)
                strtrim(read_mini("Find tag:", Null_String, ())); % Leave on stack
        % Return value on stack
}

% Get info from current line in tag buffer.
static define parse_line(qtag)
{
        variable file = "";
        variable proto = "";
        variable n = -1;
        variable line;
        variable pos, len;

        line = line_as_string();
        if (string_match(line, qtag+"\t\\([^\t]+\\)\t\\(/.+/\\)", 1)) {
                % Pattern Tag
                % "quoted" tag , TAB , ( NOT_TAB+ ) , TAB , ( / + NOT_/+ ) , /
                (pos, len) = string_match_nth(2);
                if (len > 2) {
                        len = len - 2; % leave '$' as a marker
                        proto = str_replace_all(line[[pos+2:pos+len]], "\\/", "/");
                        n = 0;
                }
        } else if (string_match(line, qtag+"\t\\([^\t]+\\)\t\\([0-9]+\\)", 1)) {
                % Numeric Tag...
                % "quoted" tag , TAB , ( NOT_TAB+ ) , TAB , ( NUMBER+ )
                (pos, len) = string_match_nth(2);
                n = integer(line[[pos:pos+len-1]]);
                proto = "";
        }

        if (n >= 0) {
                (pos, len) = string_match_nth(1);
                file = line[[pos:pos+len-1]];
        }

        return (file, proto, n);
}
%}}}

% Extended (Exhuberant) info handling. %{{{

% Get Tag Type set by Exhuberant ctags.
static define get_type()
{
        variable line = line_as_string();
        variable pos = is_substr(line, ";\"\t");
        variable type = ' ';
        variable isstatic = 0;

        if (pos) {
                type = line[pos+2];
                if (is_substr(line[[pos+4:]], "file:"))
                        isstatic = 1;
        }
        return (type, isstatic);
}

% Try to do a better choice than picking the first entry when more than one
% line exists for the same tag.
static define psyco_heuristics(start_file, tag, qtag)
{
        variable start_file_only;
        variable m = create_user_mark();
        variable tagt = tag+"\t";
        variable file, proto, n, type, isstatic;
        variable only_file;
        variable bestscore = -1, score;
        variable dbg = "";

        (,start_file_only) = parse_filename(start_file);

        while (bol_fsearch(tagt)) {
                % Maybe I should integrate these two...
                (file, proto, n) = parse_line(qtag);
                (type, isstatic) = get_type();
                (,only_file) = parse_filename(file);

                score = 0;

                % search for a #define
                if (type == 'd')
                        score += 12;
                % search for a Class tag (for C++)
                if (type == 'c')
                        score += 10;

                if (type == 'v')
                        score = 4;

                % non-prototype tag pointing to same file.
                % (try first for full path, else try only with filename and hope there
                % are only 1 file with this name).
                if (type != 'p') {
                        if (strcmp(file, start_file) == 0)
                                score += 6;
                        else if (strcmp(only_file, start_file_only) == 0)
                                score += 5;
                        else if (not isstatic)
                                % non-static non-prototype tag everywhere
                                score += 4;
                } else {
                        % any tag pointing to same file.
                        % (try first for full path, else try only with filename and hope there
                        % are only 1 file with this name).
                        if (strcmp(file, start_file) == 0)
                                score += 3;
                        else if (strcmp(only_file, start_file_only) == 0)
                                score += 2;
                        else if (not isstatic)
                                % non-static non-prototype tag everywhere
                                score += 1;
                }
                dbg += string(score);
                if (score > bestscore) {
                        bestscore = score;
                        m = create_user_mark();
                        type = toupper(type);
                }
                dbg += char(type);
        }

        goto_user_mark(m);
        return dbg;
}
%}}}

% position handling functions %{{{
static define goto_tag(tag)
{
        bol();
        () = find_word(tag, 1);

        walk_goto_current_position();
}

% Save somewhere the current tags info to avoid jumping to a tag already here.
static define store_pos(tag, file, n)
{
        NTagsOldTag  = tag;
        NTagsOldFile = expand_filename(file);
        NTagsOldPos  = n;
}
%}}}

% "High level" tags functions %{{{

% Forward declaration...
public define ntags_next_tag();

static define ntags_find(start_file, tag)
{
        variable file, proto, n;
        variable line, expr;
        variable pos, len;
        variable NTags_Save_Case_Search = CASE_SEARCH;
        variable qtag = str_quote_string(tag, "\\^$[]*.+?", '\\');

        % Update Buffer
        bm_update_buffer(NTagsBuffer, Tags_Files, &NTagsBufferTime, NULL);
        bob();

        if (NTags_Case_Sensitive >= 0)
                CASE_SEARCH = NTags_Case_Sensitive;

        if (bol_fsearch(tag + "\t")) {
                psyco_heuristics(start_file, tag, qtag);
                % DEBUG ON
                flush(string(()));
%               sleep(1);
                % DEBUG OFF
                (file, proto, n) = parse_line(qtag);
        } else {
                file = Null_String;
                proto = Null_String;
                n = -1;
        }

        CASE_SEARCH = NTags_Save_Case_Search;

	if (NTags_Prepend_Dir != NULL)
		!if (path_is_absolute(file))
			file = path_concat(NTags_Prepend_Dir, file);

        return (file, proto, n);
}

static define _search_once(proto, cont)
{
        variable toeol = (proto[-1] == '$');
        variable len;
        variable f, f1;
        variable res;

        if (NTags_Look_From_End) {
                f = &bol_bsearch;
                f1 = &go_left_1;
                !if (cont)
                        eob();
        } else {
                f = &bol_fsearch;
                f1 = &go_right_1;
                !if (cont)
                        bob();
        }

        if (toeol)
                proto = proto[[:-2]];

        res = @f(proto);
        if (toeol) {
                len = strlen(proto);
                while (res) {
                        go_right(len);
                        if (eolp()) {
                                bol();
                                if (parse_to_point() == 0)
                                        break;
                        }
                        bol();
                        @f1();
                        res = @f(proto);
                }
        }

        return res;
}

% search this tag.
static define follow_tag(file, proto, tag, n, cont)
{
        variable NTags_Save_Case_Search;
        variable res;

        if ((n < 0) or (strlen(tag) == 0))
                verror("ntags: Tag (%s) Not Found.", tag);

        !if (read_file(file))
                verror("ntags: Error opening file: %s.", file);

        if (n > 0) {
                goto_line(n);
        } else {
                NTags_Save_Case_Search = CASE_SEARCH;

                if (NTags_Case_Sensitive >= 0)
                        CASE_SEARCH = NTags_Case_Sensitive;

                res = _search_once(proto, cont);
                if ((res == 0) and (cont != 0))
                        res = _search_once(proto, 0);

                CASE_SEARCH = NTags_Save_Case_Search;

                !if (res)
                        verror("ntags: Error looking for tag (%s)[%s].", tag, proto);
        }
        goto_tag(tag);

        return 0;
}

static define ntags_find_tag(tag)
{
        variable start_file;
        variable file, proto, n;

        ERROR_BLOCK {
                walk_return_to_marked_position();
        }

        getbuf_info();
        pop; pop; exch;
        start_file = expand_filename(dircat());

        % Don't do it if we haven't moved.
        if ((NTagsOldTag == tag) and
            (NTagsOldPos == what_line()) and
            (start_file == NTagsOldFile)) {
                ntags_next_tag();
                message("ntags: tag is Here!");
                return;
        }

        % Save Current Pos
        walk_mark_current_position();

        (file, proto, n) = ntags_find(start_file, tag);

        if ((n < 0) and (NTags_Never_Ask == 0)) {
                % Tag not found, ask user (if requested) and retry.
                tag = strtrim(read_mini("(Tag Not found) Find tag:", Null_String, tag));
                if (strlen(tag))
                        (file, proto, n) = ntags_find(start_file, tag);
        }

        follow_tag(file, proto, tag, n, 0);

        store_pos(tag, file, what_line());

        % Now I can Store the old pos permanently.
        walk_store_marked_position();

        bury_buffer(NTagsBuffer);
}
%}}}

% Exported Functions %{{{
% search again the last tag.
public define ntags_next_tag()
{
        variable file, proto, n;
        variable NTags_Save_Case_Search = CASE_SEARCH;
        variable tag = NTagsOldTag;

        ERROR_BLOCK {
                walk_return_to_marked_position();
        }

        !if (bufferp(NTagsBuffer))
                return -1;

        % Save Current Pos
        walk_mark_current_position();

        setbuf(NTagsBuffer);

        if (NTags_Case_Sensitive >= 0)
                CASE_SEARCH = NTags_Case_Sensitive;

        !if (bol_fsearch(strcat(tag, "\t")))
                while (bol_bsearch(strcat(tag, "\t"))) ;

        (file, proto, n) = parse_line(tag);

	if (NTags_Prepend_Dir != NULL)
		!if (path_is_absolute(file))
			file = path_concat(NTags_Prepend_Dir, file);

        follow_tag(file, proto, tag, n, 1);

        CASE_SEARCH = NTags_Save_Case_Search;

        store_pos(tag, file, what_line());

        % Now I can Store the old pos permanently.
        if (NTags_Save_Pos_On_Next)
                walk_store_marked_position();
}

% I Don't like this name, but I retain it for compatibility.
% Find Tag Under cursor.
public define find_tag()
{
        variable tag;

        % Get Tag
        tag = get_tag();

        !if (strlen(tag))
                return;

        ntags_find_tag(tag);
}

% I need this to clear NTagsOldTag.
public define ntags_back()
{
        NTagsOldTag = "";
        walk_backward();
}

% If you set NTags_Never_Ask, you may wish to bind this function to a key.
public define ntags_ask()
{
        variable tag = get_tag();

        tag = read_mini("Search tag:", tag, "");

        !if (strlen(tag))
                return;

        ntags_find_tag(tag);
}

public define ntags_bg_open()
{
	bm_background_open(NTagsBuffer, Tags_Files, &NTagsBufferTime);
}
%}}}

provide("ntags");

% This is The End!
