%
% By Dave Kuhlman ( gratefully stolen by BukinD )
%
% Switch to previous or next buffer.
%   This code taken from ide_next_buffer() in ide.sl.
%
% Then in your jedrc:
% Bind Alt-. and Alt-, (Meta-period and Meta-comma) to next_buffer().
% setkey ("db_next_buffer(0)", "\e,");
% setkey ("db_next_buffer(1)", "\e.");

define db_next_buffer (previous)
{
    variable n, buf;
    n = buffer_list (); % get the buffers on the stack
    if (previous)
    {
        _stk_reverse (n-1);
    }
    loop (n) {
        buf = ();
        n--;
        % Skip *scratch* and other buffers that are not of interest.
        if ((buf[0] == '*') or (buf[0] == ' '))
        {
            continue;
        }
        sw2buf (buf);
        _pop_n (n);
        return;
    }
}
