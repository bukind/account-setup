%
% simple kumac mode for JED (adopted from TeX mode)
% Copyleft (C) 1999, Budker Institute of Nuclear Physics
%                    Dmitry Bukin <D.A.Bukin@inp.nsk.su>
%
%   you can:
% set_color( "keyword", "fg", "bg" );  somewhere in your .jedrc
%   and, usually you do:
% autoload( "db_kumac_mode", "kumac.sl" );
% add_mode_for_extension( "db_kumac", "kumac" );

$1 = "Kumac";

create_syntax_table($1);
% define_syntax( "*", "", '%', $1);      %  comment
define_syntax( "([", ")]", '(', $1);   %  delimiters
define_syntax( '"', '"', $1);          %  char delimiter
define_syntax( '\'', '\'', $1);        %  char delimiter
define_syntax( "[]", '<', $1);
% define_syntax( '\$', '\\', $1);	       %  char delimiter
define_syntax( "$0-9a-zA-Z_", 'w', $1);%  words
define_syntax( "-+0-9eEdD.", '0', $1); %  numbers
define_syntax( ",.", ',', $1); 	       %  delimiter
define_syntax( "-+/*=", '+', $1);
set_syntax_flags( $1, 1 | 2 );
set_fortran_comment_chars($1, "*");

#ifdef HAS_DFA_SYNTAX
% enable_highlight_cache( "kumac.dfa", $1);
% define_highlight_rule("\*.*$", "comment", $1);
% define_highlight_rule("\$[A-Za-z]+", "keyword", $1);
% define_highlight_rule("\\'[^\\']*\\'", "string", $1);
% define_highlight_rule("\\[[A-Za-z0-9]+\\]", "keyword", $1);
% define_highlight_rule("[\\(\\[\\]\\),\\.]", "delimiter", $1);
% define_highlight_rule("[\\-\\+/\\*=<>]", "operator", $1);
% define_highlight_rule("[A-Za-z][A-Za-z_0-9].*/[A-Za-z123][A-Za-z_0-9]*", "keyword", $1);
% define_highlight_rule("[\\(\\)]", "Qdelimiter", $1);
% define_highlight_rule("\'([^\\\\\']|\\\\.)*\'", "string", $1);
% define_highlight_rule(".", "normal", $1);
% build_highlight_table( $1 );
#endif

% they must be alphabetically ordered
() = define_keywords($1, "doifin", 2);
() = define_keywords($1, "exefor", 3);
() = define_keywords($1, "caseelseexecgotoquitthenwait", 4);
() = define_keywords($1, "comisenddoendifexitmmacroshellstopm", 5);
() = define_keywords($1, "breaklelseifendforimportreturn", 6);
() = define_keywords($1, "endcase", 7);
() = define_keywords($1, "endwhile", 8);

() = define_keywords_n($1, "cdeqgegthihpleliltnentoporplprvewr", 2, 1);
() = define_keywords_n($1, "andcrecutdelerrfitfuninpnotntuvecwri", 3, 1);
() = define_keywords_n($1, "aerrcopyfileglobhistloopmessnullplotprojreadscanvectzone", 4, 1);
() = define_keywords_n($1, "applichainclosefmessgraphhplotinputprintsigmauwfunwrite", 5, 1);
() = define_keywords_n($1, "atitlecreateerrorsuwfuncvector", 6, 1);
() = define_keywords_n($1, "messageproject", 7, 1);
() = define_keywords_n($1, "fmessage", 8, 1);
() = define_keywords_n($1, "histogram", 9, 1);
() = define_keywords_n($1, "application", 11, 1);

% () = define_keywords_n($1, "lipl", 2, 2);
() = define_keywords_n($1, "maxminoptsetsum", 3, 2);
() = define_keywords_n($1, "$env$lenmaxvminvsqrtvmaxvminvsum", 4, 2);
() = define_keywords_n($1, "$call$exec$vdim$vlen$wordarray", 5, 2);
() = define_keywords_n($1, "$dcall$hinfo$icall$index$lower$shell$sigma$upper$wordsoption", 6, 2);
() = define_keywords_n($1, "$fexist$hexist$option$vexist", 7, 2);
() = define_keywords_n($1, "$grafinfo", 9, 2);
() = define_keywords_n($1, "$substring", 10, 2);

define db_kumac_mode()
{
  variable mode = "Kumac";
  % use_keymap(kumode);
  %  set_buffer_hook( "wrap_hook" );
  set_mode( mode, 1 );
  use_syntax_table( mode );
}
