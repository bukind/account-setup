% -*- mode: slang; -*-

%----------------------------------------------------------------------
% Russian hook for jed
% Copyleft (C) 1997, Budker Institute of Nuclear Physics
%                    Dmitry Bukin <D.A.Bukin@inp.nsk.su>
%----------------------------------------------------------------------

% Truly Russian table (as it uses both Koi8 and QWERTY layout)
% --- Small russian letters
% you have to bind some key to db_russian_hook(), for ex:
%   setkey("db_russian_hook()","\er");
make_keymap("Russian");
definekey(" �","a","Russian");
definekey(" �","b","Russian");
definekey(" �","w","Russian");
definekey(" �","g","Russian");
definekey(" �","d","Russian");
definekey(" �","e","Russian");
%  a letter � is ASCII 0xa3
definekey(" �","&","Russian");
definekey(" �","v","Russian");
definekey(" �","z","Russian");
definekey(" �","i","Russian");
definekey(" �","j","Russian");
definekey(" �","k","Russian");
definekey(" �","l","Russian");
definekey(" �","m","Russian");
definekey(" �","n","Russian");
definekey(" �","o","Russian");
definekey(" �","p","Russian");
definekey(" �","r","Russian");
definekey(" �","s","Russian");
definekey(" �","t","Russian");
definekey(" �","u","Russian");
definekey(" �","f","Russian");
definekey(" �","h","Russian");
definekey(" �","c","Russian");
definekey(" �","=","Russian");
definekey(" �","[","Russian");
definekey(" �","]","Russian");
definekey(" �","_","Russian");
definekey(" �","y","Russian");
definekey(" �","x","Russian");
definekey(" �","\\","Russian");
definekey(" �","`","Russian");
definekey(" �","q","Russian");
% --- Capital Russian letters
definekey(" �","A","Russian");
definekey(" �","B","Russian");
definekey(" �","W","Russian");
definekey(" �","G","Russian");
definekey(" �","D","Russian");
definekey(" �","E","Russian");
% a letter � is ASCII 0xb3
definekey(" �","V","Russian");
definekey(" �","Z","Russian");
definekey(" �","I","Russian");
definekey(" �","J","Russian");
definekey(" �","K","Russian");
definekey(" �","L","Russian");
definekey(" �","M","Russian");
definekey(" �","N","Russian");
definekey(" �","O","Russian");
definekey(" �","P","Russian");
definekey(" �","R","Russian");
definekey(" �","S","Russian");
definekey(" �","T","Russian");
definekey(" �","U","Russian");
definekey(" �","F","Russian");
definekey(" �","H","Russian");
definekey(" �","C","Russian");
definekey(" �","+","Russian");
definekey(" �","{","Russian");
definekey(" �","}","Russian");
% a letter � is ASCII 0xff - and this is control character
definekey(" �","Y","Russian");
definekey(" �","X","Russian");
definekey(" �","|","Russian");
definekey(" �","~","Russian");
definekey(" �","Q","Russian");
%  End of Russian keymap table -- hook is defined later in the file
%----------------------------------------------------------------------

% --- the russian hook itself
variable RUSBUF, RUSMAP;
RUSBUF = "";		     		% The buffer in which Russian was set
RUSMAP = "";				% Keymap which was subst. by Russian

define db_russian_hook()
{
  variable NEWBUF;
  
  if ( 0 == strlen( RUSMAP ) )	      	% Latin mode - switch into Rus.
    {
      RUSBUF = whatbuf ();
      RUSMAP = what_keymap ();
      use_keymap( "Russian" );
    }
  else					% Switch back
    {
      NEWBUF = whatbuf ();
      if ( strcmp( NEWBUF, RUSBUF ) != 0 ) % Need to switch old buffer back
	{
	  setbuf( RUSBUF );
	  use_keymap( RUSMAP );
	  RUSBUF = NEWBUF;
	  sw2buf ( RUSBUF );
	  RUSMAP = what_keymap ();
	  use_keymap ( "Russian" );
	}
      else				% Switch back into Latin
	{
	  use_keymap ( RUSMAP );
	  RUSMAP = "";
	}
    }
  if ( 0 != strlen( RUSMAP ) )
    {
      variable RUSLINE;
      RUSLINE = strcat( Status_Line_String, "-Koi8" );
      set_status_line( RUSLINE, 0 );
    }
  else
    {
      set_status_line( Status_Line_String, 0 );
    }
}




% Russian table for those disabled individuals who get used to red layout
% --- Small russian letters
% you have to bind some key to db_altrussian_hook(), for ex:
%   setkey("db_altrussian_hook()","\er");
make_keymap("AltRussian");
definekey(" �","f","AltRussian");
definekey(" �",",","AltRussian");
definekey(" �","d","AltRussian");
definekey(" �","u","AltRussian");
definekey(" �","l","AltRussian");
definekey(" �","t","AltRussian");
definekey(" �",";","AltRussian");
definekey(" �","p","AltRussian");
definekey(" �","b","AltRussian");
definekey(" �","q","AltRussian");
definekey(" �","r","AltRussian");
definekey(" �","k","AltRussian");
definekey(" �","v","AltRussian");
definekey(" �","y","AltRussian");
definekey(" �","j","AltRussian");
definekey(" �","g","AltRussian");
definekey(" �","h","AltRussian");
definekey(" �","c","AltRussian");
definekey(" �","n","AltRussian");
definekey(" �","e","AltRussian");
definekey(" �","a","AltRussian");
definekey(" �","[","AltRussian");
definekey(" �","w","AltRussian");
definekey(" �","x","AltRussian");
definekey(" �","i","AltRussian");
definekey(" �","o","AltRussian");
definekey(" �","]","AltRussian");
definekey(" �","s","AltRussian");
definekey(" �","m","AltRussian");
definekey(" �","'","AltRussian");
definekey(" �",".","AltRussian");
definekey(" �","z","AltRussian");
% --- Capital Russian letters
definekey(" �","F","AltRussian");
definekey(" �","<","AltRussian");
definekey(" �","D","AltRussian");
definekey(" �","U","AltRussian");
definekey(" �","L","AltRussian");
definekey(" �","T","AltRussian");
definekey(" �",":","AltRussian");
definekey(" �","P","AltRussian");
definekey(" �","B","AltRussian");
definekey(" �","Q","AltRussian");
definekey(" �","R","AltRussian");
definekey(" �","K","AltRussian");
definekey(" �","V","AltRussian");
definekey(" �","Y","AltRussian");
definekey(" �","J","AltRussian");
definekey(" �","G","AltRussian");
definekey(" �","H","AltRussian");
definekey(" �","C","AltRussian");
definekey(" �","N","AltRussian");
definekey(" �","E","AltRussian");
definekey(" �","A","AltRussian");
definekey(" �","{","AltRussian");
definekey(" �","W","AltRussian");
definekey(" �","X","AltRussian");
definekey(" �","I","AltRussian");
definekey(" �","O","AltRussian");
%   definekey(" �","_","AltRussian"); - no capital letter
definekey(" �","S","AltRussian");
definekey(" �","M","AltRussian");
definekey(" �","\"","AltRussian");
definekey(" �",">","AltRussian");
definekey(" �","Z","AltRussian");

definekey(" \"","@","AltRussian");
definekey(" \;","$","AltRussian");

% --- it is an easter egg, :)
% definekey(" \:","^","AltRussian");
definekey("insert(\", ���������,\")","^","AltRussian");

definekey(" ?","&","AltRussian");
definekey(" .","/","AltRussian");
definekey(" ,","?","AltRussian");
definekey(" /","\\","AltRussian");
definekey(" \\","|","AltRussian");
%  End of AltRussian keymap table -- hook is defined later in the file
%----------------------------------------------------------------------

% --- the AltRussian hook itself
variable ALTRUSBUF, ALTRUSMAP;
ALTRUSBUF = "";		     		% The buffer in which AltRussian was set
ALTRUSMAP = "";				% Keymap which was subst. by AltRussian

define db_altrussian_hook()
{
  variable NEWBUF;

  if ( 0 == strlen( ALTRUSMAP ) )      	% Latin mode - switch into Rus.
    {
      ALTRUSBUF = whatbuf ();
      ALTRUSMAP = what_keymap ();
      use_keymap( "AltRussian" );
    }
  else					% Switch back
    {
      NEWBUF = whatbuf ();
      if ( strcmp( NEWBUF, ALTRUSBUF ) != 0 ) % Need to switch old buffer back
	{
	  setbuf( ALTRUSBUF );
	  use_keymap( ALTRUSMAP );
	  ALTRUSBUF = NEWBUF;
	  sw2buf ( ALTRUSBUF );
	  ALTRUSMAP = what_keymap ();
	  use_keymap ( "AltRussian" );
	}
    else				% Switch back into Latin
	{
	  use_keymap ( ALTRUSMAP );
	  ALTRUSMAP = "";
	}
    }
  if ( 0 != strlen( ALTRUSMAP ) )
    {
      variable RUSLINE;
      RUSLINE = strcat( Status_Line_String, "-����" );
      set_status_line( RUSLINE, 0 );
    }
  else
    {
      set_status_line( Status_Line_String, 0 );
    }
}
