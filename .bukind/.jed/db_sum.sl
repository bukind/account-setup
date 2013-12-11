%
% Copyleft (C) 1999, Budker Institute of Nuclear Physics
%                    Dmitry Bukin <D.A.Bukin@inp.nsk.su>
%
%!%  the procedure sum up the column of numeric values (type = 0)
%!%  and take the average of these values ( type = 1 ).
%!%
%!%  usually you place the strings into your .jedrc:
%!%  () = evalfile( "<full path to this file>" );
%!%  setkey("db_sum_region(0)","^Xrs");  % to sum up
%!%  setkey("db_sum_region(1)","^Xra");  % to make average
%  Operation:
%   select region as for rectangle commands, then invoke the procedure.
%   it will message the result in minibuffer, and place it into kill_array,
%   so that you can insert it with `yp_yank' command.
%

% if ( _jed_version < 9807 ) {
%   () = evalfile("/home/bukind/etc/atof.sl"); % float conversion
% }

define db_sum_region ( type ) {

  variable end_line, endc, beg, begc;
  variable n, i, l, pp, prec, s, sum, sumf;
  variable a_buffer;

  check_region(0);             % make canonical region (1st mark - 2nd mark)
  !if ( bufferp("*scratch*") ) {
    message ("\bBuffer *scratch* not found");
  }
  endc = what_column();        % 2nd mark parameters
  end_line = what_line();      %
  pop_mark_1 ();
  beg = what_line();           % 1st mark parameters
  begc = what_column();
  if ( endc < begc ) {         % make (beg,begc) to be left-upper
    prec = endc;	       % and (end_line,endc) to be right-lower corner  
    endc = begc;
    begc = prec;
  }

  n = end_line - beg;  ++n;    % number of lines
  
                               % extract substrings, calc the sum
  goto_line(beg);
  prec = -1;
  sum = 0.;
  for ( i = 0; i < n; ++i ) {
    goto_column(begc);
    push_mark_eol();           % push mark and goto eol
    if ( what_column() > endc )
      goto_column(endc);
    s = bufsubstr();           % get the substring
    pp = is_substr( s, "." );  % find the period position
    l = strlen( s );
    if ( pp > 0 ) {
      prec = l - pp;
    }
    sum = sum + atof(s);
    go_down_1 ();              % next line
  }

                               % convert number into the string
  if ( type ) {
    sum = sum / n;
  }
  pp = prec;
  if ( pp < 0 ) pp = 0;
  sumf = strtrim( Sprintf( strncat("%15.",string(pp),"f",3), sum, 1) );
  if ( prec < 0 ) {            % remove decimal point
    l = is_substr( sumf, "." ) - 1;
    sumf = substr( sumf, 1, l );
  }
  a_buffer = whatbuf();        % use *scratch* as a temporary place
  setbuf( "*scratch*" );
  push_mark();
  insert(sumf);
  yp_kill_region();            % save result in yp_kill'ed region
  setbuf( a_buffer );

  goto_column( begc );
  flush ( Sprintf( "Sum is <%s>.", sumf, 1 ) );
}

%
% ratio must be a number in range 0. - 1.
%
define db_slideline ( ratio ) {
  variable c;

  if ( ratio < 0 ) {
    ratio = 0.;
  }
  if ( ratio > 1 ) {
    ratio = 1.;
  }

  eol();
  c = integer( Sprintf("%f", what_column()*ratio, 1) );
  goto_column(c);
}


%%
%%  Make a line upper or lower case 
%%
define db_xform_line () {
  if ( markp() ) {
    % the region is already marked - process the whole region
  } else {
    % we should process only one line
    bol(); push_mark();
    if ( 1 != down(1) ) {
      % cannot move to the next line - go to the end of this one instead
      eol();
    }
  }
  % translate the region
  xform_region(());
}
define db_downcase_line() {
  db_xform_line('d');
}
define db_upcase_line() {
  db_xform_line('u');
}
