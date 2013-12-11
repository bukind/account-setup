% Autoload for functions defined in ntags.sl.

$0 = _stkdepth ();
_autoload(
          "find_tag",                               "ntags.sl",
          "ntags_next_tag",                         "ntags.sl",
          "ntags_back",                             "ntags.sl",
          "ntags_ask",                              "ntags.sl",
          "ntags_bg_open",                          "ntags.sl",
          (_stkdepth () - $0) / 2          %  matches start of _autoload
	  );

