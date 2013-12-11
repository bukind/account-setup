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
definekey(" а","a","Russian");
definekey(" б","b","Russian");
definekey(" в","w","Russian");
definekey(" г","g","Russian");
definekey(" д","d","Russian");
definekey(" е","e","Russian");
%  a letter ё is ASCII 0xa3
definekey(" ё","&","Russian");
definekey(" ж","v","Russian");
definekey(" з","z","Russian");
definekey(" и","i","Russian");
definekey(" й","j","Russian");
definekey(" к","k","Russian");
definekey(" л","l","Russian");
definekey(" м","m","Russian");
definekey(" н","n","Russian");
definekey(" о","o","Russian");
definekey(" п","p","Russian");
definekey(" р","r","Russian");
definekey(" с","s","Russian");
definekey(" т","t","Russian");
definekey(" у","u","Russian");
definekey(" ф","f","Russian");
definekey(" х","h","Russian");
definekey(" ц","c","Russian");
definekey(" ч","=","Russian");
definekey(" ш","[","Russian");
definekey(" щ","]","Russian");
definekey(" ъ","_","Russian");
definekey(" ы","y","Russian");
definekey(" ь","x","Russian");
definekey(" э","\\","Russian");
definekey(" ю","`","Russian");
definekey(" я","q","Russian");
% --- Capital Russian letters
definekey(" А","A","Russian");
definekey(" Б","B","Russian");
definekey(" В","W","Russian");
definekey(" Г","G","Russian");
definekey(" Д","D","Russian");
definekey(" Е","E","Russian");
% a letter Ё is ASCII 0xb3
definekey(" Ж","V","Russian");
definekey(" З","Z","Russian");
definekey(" И","I","Russian");
definekey(" Й","J","Russian");
definekey(" К","K","Russian");
definekey(" Л","L","Russian");
definekey(" М","M","Russian");
definekey(" Н","N","Russian");
definekey(" О","O","Russian");
definekey(" П","P","Russian");
definekey(" Р","R","Russian");
definekey(" С","S","Russian");
definekey(" Т","T","Russian");
definekey(" У","U","Russian");
definekey(" Ф","F","Russian");
definekey(" Х","H","Russian");
definekey(" Ц","C","Russian");
definekey(" Ч","+","Russian");
definekey(" Ш","{","Russian");
definekey(" Щ","}","Russian");
% a letter Ъ is ASCII 0xff - and this is control character
definekey(" Ы","Y","Russian");
definekey(" Ь","X","Russian");
definekey(" Э","|","Russian");
definekey(" Ю","~","Russian");
definekey(" Я","Q","Russian");
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
definekey(" а","f","AltRussian");
definekey(" б",",","AltRussian");
definekey(" в","d","AltRussian");
definekey(" г","u","AltRussian");
definekey(" д","l","AltRussian");
definekey(" е","t","AltRussian");
definekey(" ж",";","AltRussian");
definekey(" з","p","AltRussian");
definekey(" и","b","AltRussian");
definekey(" й","q","AltRussian");
definekey(" к","r","AltRussian");
definekey(" л","k","AltRussian");
definekey(" м","v","AltRussian");
definekey(" н","y","AltRussian");
definekey(" о","j","AltRussian");
definekey(" п","g","AltRussian");
definekey(" р","h","AltRussian");
definekey(" с","c","AltRussian");
definekey(" т","n","AltRussian");
definekey(" у","e","AltRussian");
definekey(" ф","a","AltRussian");
definekey(" х","[","AltRussian");
definekey(" ц","w","AltRussian");
definekey(" ч","x","AltRussian");
definekey(" ш","i","AltRussian");
definekey(" щ","o","AltRussian");
definekey(" ъ","]","AltRussian");
definekey(" ы","s","AltRussian");
definekey(" ь","m","AltRussian");
definekey(" э","'","AltRussian");
definekey(" ю",".","AltRussian");
definekey(" я","z","AltRussian");
% --- Capital Russian letters
definekey(" А","F","AltRussian");
definekey(" Б","<","AltRussian");
definekey(" В","D","AltRussian");
definekey(" Г","U","AltRussian");
definekey(" Д","L","AltRussian");
definekey(" Е","T","AltRussian");
definekey(" Ж",":","AltRussian");
definekey(" З","P","AltRussian");
definekey(" И","B","AltRussian");
definekey(" Й","Q","AltRussian");
definekey(" К","R","AltRussian");
definekey(" Л","K","AltRussian");
definekey(" М","V","AltRussian");
definekey(" Н","Y","AltRussian");
definekey(" О","J","AltRussian");
definekey(" П","G","AltRussian");
definekey(" Р","H","AltRussian");
definekey(" С","C","AltRussian");
definekey(" Т","N","AltRussian");
definekey(" У","E","AltRussian");
definekey(" Ф","A","AltRussian");
definekey(" Х","{","AltRussian");
definekey(" Ц","W","AltRussian");
definekey(" Ч","X","AltRussian");
definekey(" Ш","I","AltRussian");
definekey(" Щ","O","AltRussian");
%   definekey(" ъ","_","AltRussian"); - no capital letter
definekey(" Ы","S","AltRussian");
definekey(" Ь","M","AltRussian");
definekey(" Э","\"","AltRussian");
definekey(" Ю",">","AltRussian");
definekey(" Я","Z","AltRussian");

definekey(" \"","@","AltRussian");
definekey(" \;","$","AltRussian");

% --- it is an easter egg, :)
% definekey(" \:","^","AltRussian");
definekey("insert(\", панимаешь,\")","^","AltRussian");

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
      RUSLINE = strcat( Status_Line_String, "-Альт" );
      set_status_line( RUSLINE, 0 );
    }
  else
    {
      set_status_line( Status_Line_String, 0 );
    }
}
