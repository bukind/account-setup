% Autoload for functions defined somewhere in this directory tree.
%_debug_info = 1;
_traceback = 1;

define sau_autoload()
{
	variable BaseDir;
	variable MyDir = "/ntags_autoload/";
	variable MyFile;
	variable files, i, CurDir;


	foreach (strchop(get_jed_library_path(), ',', 0)) {
		BaseDir = ();
		CurDir = expand_filename(BaseDir + MyDir);
		files = listdir (CurDir);
		if (files != NULL) {
			i = array_map (Int_Type, &string_match, files, "^.*\.sl$", 1);
			files = files[where (i)];

			foreach(files) {
				CurDir; exch;
				() + () ;  MyFile = expand_filename(());
				% Why Myfile = expand_filename(() + ()); doesn't work?

				flush("evaluating: "+ MyFile);
				() = evalfile(MyFile);
			}
		}
	}
}

sau_autoload();
