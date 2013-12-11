% Autoload for functions defined somewhere in this directory tree.

$0 = _stkdepth ();
_autoload(
          "intellijed",                             "ntags_cfun.sl",
          "intellijed_insert",                      "ntags_cfun.sl",
          "intellipointer",                         "ntags_cfun.sl",

          (_stkdepth () - $0) / 2          %  matches start of _autoload
	  );

