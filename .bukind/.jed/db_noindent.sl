%----------------------------------------------------------------------
% No-indent-after-newline switcher for jed
% Copyleft (C) 2004, Budker Institute of Nuclear Physics
%                    Dmitry Bukin <D.A.Bukin@inp.nsk.su>
%----------------------------------------------------------------------

variable NEWLINE_DOES_INDENT;
NEWLINE_DOES_INDENT = 1;

define db_toggle_noindent()
{
   if ( 1 == NEWLINE_DOES_INDENT ) {
      NEWLINE_DOES_INDENT = 0;
      setkey( "newline", "^M" );
      message("No indent after newline");
   } else {
      NEWLINE_DOES_INDENT = 1;
      setkey( "newline_and_indent", "^M" );
      message("Indent after newline");
   }
}
