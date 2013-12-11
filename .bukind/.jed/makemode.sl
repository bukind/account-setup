%
% simple make mode for JED (adopted from TeX mode)
% Copyleft (C) 2007, Budker Institute of Nuclear Physics
%                    Dmitry Bukin <D.A.Bukin@inp.nsk.su>
%
define db_make_mode()
{
    variable mode = "Make";
    no_mode();
    set_mode( mode, 1 );
    local_setkey("self_insert_cmd","\t");
    run_mode_hooks( "make_mode_hook" );
}
