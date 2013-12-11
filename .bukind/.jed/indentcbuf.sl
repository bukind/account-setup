%
% Indenting a C/C++ selection
%

define db_indentcbuf () {

   variable end_line, beg;

   check_region(0);
   end_line = what_line(); % 2nd mark
   pop_mark_1();
   beg = what_line();      % 1st mark
   
   for ( ; beg < end_line ; ++beg ) {
      goto_line( beg );
      indent_line();
      go_down_1();
   }

}
