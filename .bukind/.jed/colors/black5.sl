%
%  Copyleft (C) 1999, Budker Institute of Nuclear Physics
%                     Dmitry Bukin <D.A.Bukin@inp.nsk.su>
%

$1 = "lightgray"; $2 = "black";
set_color("menu", "white", "blue");               % menu bar      
set_color("normal", $1, $2);	                  % default fg/bg
set_color("status", "yellow", "blue");	          % status or mode line
set_color("region", "yellow", "brightmagenta");   % for marking regions
set_color("operator", $1, $2);      		  % +, -, etc..  
set_color("number", "brightcyan", $2);	          % 10, 2.71,... TeX formulas
set_color("comment", "brightgreen", "gray");      % /* comment */    
set_color("string", "brightmagenta", $2);     	  % "string" or 'char'  
set_color("keyword", "brightred", $2);	          % if, while, unsigned, ...  
set_color("keyword1", "green", $2);               % keyword1
set_color("keyword2", "white", $2);               % keyword2
% set_color("keyword1", "gray", $2);	          % malloc, exit, etc...
set_color("delimiter", $1, $2);     		  % {}[](),.;...  
set_color("preprocess", "yellow", $2);            % #ifdef ....  
set_color("message", "brightgreen", $2);          % color for messages
set_color("error", "brightred", $2);              % color for errors
set_color("dollar", "magenta", $2);               % color dollar sign continuation
set_color("...", "red", $2);			  % folding indicator
