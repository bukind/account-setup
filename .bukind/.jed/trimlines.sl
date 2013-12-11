% A function from Gunter Milde.
% It strips endofline whitespaces

% Trim buffer but keep multiple blank lines:
public define trim_buffer_lines()
{
  % remove whitespace at end of lines
  push_spot_bob();
  do {
	eol_trim();
  }
  while (down_1());
  % remove empty lines at end of buffer
  eob();
  do {
	go_left_1();
	if (bolp() and eolp())
	  del();
  }
  while (bolp());

  pop_spot();
  !if (BATCH) message("done.");
}
