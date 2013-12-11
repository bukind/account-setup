% Autoload for functions defined somewhere in this directory tree.

$0 = _stkdepth ();
_autoload(
          "search_one_word",                        "wordsrch.sl",
          "search_word",                            "wordsrch.sl",
          "match_word",                             "wordsrch.sl",
          "search_change_case",                     "wordsrch.sl",
          "search_change_wholeword",                "wordsrch.sl",
          "generic_search",                         "wordsrch.sl",
          "get_word",                               "wordsrch.sl",
          (_stkdepth () - $0) / 2          %  matches start of _autoload
          );

