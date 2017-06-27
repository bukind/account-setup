% An attempt to create a Golang mode.
% Gracefully stolen from pymode.
%
% Authors: bukind

_traceback = 1;

$1 = "golang";

% define golang_indent_line()
% {
%   variable col;
%  col = golang_indent_calculate();
%  bol_trim();
%   golang_whitespace( col );
% }

create_syntax_table ($1);
define_syntax ("//", "", '%', $1);  % comments
define_syntax ("([{", ")]}", '(', $1);  % delimiters
define_syntax ('"', '"', $1);   % quoted strings
define_syntax ('`', '"', $1);   % quoted strings
define_syntax ('\'', '\'', $1);  % quoted characters
define_syntax ("0-9a-zA-Z_", 'w', $1);		% words
define_syntax ("-+0-9a-fA-FjJlLxX.", '0', $1);	% Numbers
define_syntax (",;.:", ',', $1);		% punctuation
define_syntax ("%-+/&*=<>|!~^", '+', $1);	% operators
set_syntax_flags ($1, 0);			% keywords ARE case-sensitive

() = define_keywords ($1, "ifgo", 2); % all keywords of length 2
() = define_keywords ($1, "formapvar", 3); % of length 3 ....
() = define_keywords ($1, "casechanelsefuncgototype", 4);
() = define_keywords ($1, "breakconstdeferrange", 5);
() = define_keywords ($1, "importreturnselectstructswitch", 6);
() = define_keywords ($1, "defaultpackage", 7);
() = define_keywords ($1, "continue", 8);
() = define_keywords ($1, "interface", 9);
() = define_keywords ($1, "fallthrough", 11);

% No dfa yet

%!%+
%\function{golang_mode}
%\synopsis{golang_mode}
%\usage{golang_mode ()}
%\description
% An attempt to create a golang mode.
%
% Hooks: \var{golang_mode_hook}
%!%-
define golang_mode ()
{
  variable golang = "golang";

  set_mode (golang, 0x4); % flag value of 4 is generic language mode
  use_syntax_table (golang);
  run_mode_hooks ("golang_mode_hook");
}
