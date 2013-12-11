% Autoload for functions defined somewhere in this directory tree.

$0 = _stkdepth ();
_autoload(
	  "walk_mark_current_position",		"ntags_walk.sl",
	  "walk_store_marked_position",		"ntags_walk.sl",
	  "walk_goto_current_position",		"ntags_walk.sl",
	  "walk_backward",			"ntags_walk.sl",
	  "walk_forward",			"ntags_walk.sl",
	  "walk_return_to_marked_position",	"ntags_walk.sl",

          (_stkdepth () - $0) / 2          %  matches start of _autoload
	  );

