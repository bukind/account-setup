% An attempt to create a Golang mode for jed.
% Mostly gratefully stolen from pymode.
% Feel free to improve.
%
% Authors: bukin.dima@gmail.com
%
% Caveats:
%  many :)

$1 = "golang";

!if (keymap_p ($1)) make_keymap ($1);

definekey ("golang_insert_char_indent('}')", "}", $1);
definekey ("golang_insert_char_indent(':')", ":", $1);
definekey ("golang_insert_char_indent(')')", ")", $1);

private define golang_line_starts_with_ket()
{
  bol_skip_white();
  if (looking_at_char('}') ||
      looking_at_char(')'))
    return 1;
  return 0;
}

private define golang_line_starts_case()
{
  bol_skip_white();
  push_mark();
  skip_chars("a-z");
  return is_list_element("case,default", bufsubstr(), ',') > 0;
}

% TODO: This needs improvement to prevent special cases.
% such as:  a := " { // "
private define golang_line_ends_with_bra()
{
  eol();
  if (bfind_char('{')) {
    go_right(1);
    skip_white();
    if (eolp() or looking_at("//"))
      return 1;
  }
  eol();
  if (bfind_char('(')) {
    go_right(1);
    skip_white();
    if (eolp() or looking_at("//"))
      return 1;
  }
  return 0;
}

private define golang_indent_calculate()
{
  variable col = 0;
  variable endblock = 0;

  EXIT_BLOCK {
    pop_spot ();
    return col;
  }

  if (golang_line_starts_with_ket() ||
      golang_line_starts_case())
    endblock = 1;

  % go to previous non blank line
  push_spot_bol ();
  !if (re_bsearch ("[^ \t\n]"))
    return;
  bol_skip_white();

  col = what_column() - 1;

  if (golang_line_ends_with_bra() ||
      golang_line_starts_case())
    col += TAB;
  if (endblock)
    col -= TAB;
}

private define golang_whitespace(cnt)
{
  loop (cnt / TAB) insert_char('\t');
}

% Indent the current line
define golang_indent_line()
{
  variable col;
  col = golang_indent_calculate();
  bol_trim ();
  golang_whitespace( col );
}

% Insert a newline and indent the newly created line.
define golang_newline_and_indent()
{
  newline();
  golang_indent_line();
}

% Insert a char and possibly indent the current line.
% Keep the position of the cursor just after the char.
define golang_insert_char_indent(char)
{
  variable i;
  insert_char(char);
  i = what_column();
  bol_skip_white();
  i = i - what_column();
  golang_indent_line();
  bol_skip_white();
  goto_column(i + what_column() - 1);
  del();
  call("self_insert_cmd");
}

create_syntax_table ($1);
define_syntax ("//", "", '%', $1);  % comments
define_syntax ("([{", ")]}", '(', $1);  % delimiters
define_syntax ('"', '"', $1);   % quoted strings
define_syntax ('`', '"', $1);   % quoted strings
define_syntax ('\'', '\'', $1);  % quoted characters
define_syntax ('\\', '\\', $1);  % escape
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

  TAB = TAB_DEFAULT;
  if (TAB == 0) {
    TAB = 4;
  }

  set_mode (golang, 0x4); % flag value of 4 is generic language mode
  use_keymap(golang);
  set_buffer_hook ("indent_hook", "golang_indent_line");
  set_buffer_hook ("newline_indent_hook", "golang_newline_and_indent");
  use_syntax_table (golang);
  run_mode_hooks ("golang_mode_hook");
}
