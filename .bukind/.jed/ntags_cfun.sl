% cfun.sl       -*- mode: SLang; mode: fold -*-
% Fun and strange C support functions
%
%_debug_info = 1;
%_traceback = 1;
%
implements("CFun");

require("wordsrch");
require("ntags");

% To cope with missing new_*_of_function;
variable _func_top = __get_reference("new_top_of_function");
if (_func_top == NULL)
  _func_top = &c_top_of_function;

% Strange, fun functions %{{{

define get_intellijed_string()
{
        variable cbuf = whatbuf();
        variable start_file;
        variable tag;
        variable file, proto, n;

        insert("(");

        go_left(1);
        tag = get_word();
        go_right(1);

        !if (strlen(tag))
                return NULL;

        getbuf_info();
        pop; pop; exch;
        start_file = expand_filename(dircat());

        (file, proto, n) = NTags->ntags_find(start_file, tag);
        setbuf(cbuf);

        if ((proto == NULL) or (strlen(proto) == 0)) {
                return NULL;
        }

        if (proto[-1] == '$')
                proto = proto[[:-2]];

        return proto;
}


% A Fun function: try binding '(' to this function, perhaps in the c_mode_hook().
% then write a function name (covered by tags file), press the '(' key, and look
% the message that appears on the bottom line. (this works if the function
% definition is all on one line).
public define intellijed()
{
        if (not bufferp("*tags*")) {
                insert("(");
%                message("no tag file loaded");
                return;
        }

        get_intellijed_string();
        dup;
        if (() == NULL) {
                pop;
                message("no clue.");
        } else {
                if (1 == is_defined("message_keep"))
                        eval("message_keep");
                else
                        message(());
        }
}

public define intellijed_insert()
{
        variable proto = get_intellijed_string();
        variable end = 0;

        if (proto == NULL)
                return;

        if (input_pending (5))
                return;

        push_mark();
        push_mark();
        go_left(1);
        del();
        insert(proto);
        narrow_to_region();
        if (bsearch_char(';') == 0)
                insert(";");
        eob();
        if (bsearch_char(')')) {
                call("goto_match");
                push_mark();
                bob();
                call("kill_region");
                call("goto_match");
                do {
                        bskip_word_chars();
                        push_mark();
                        if (bsearch_char(',') == 0) {
                                end = 1;
                                bsearch_char('(');
                        }
                        go_right(1);
                        call("kill_region");
                        if (end == 0) {
                                insert(" ");
                                go_left(2);
                        }
                } while (end == 0);
                widen_region();
                pop_mark(0);
        } else {
                eob();
                widen_region();
                call("kill_region");
                insert("(");
        }
        message(proto);
}

% Another useful, but 'unsafe' function. This one tries to guess the type of the
% variable under the cursor, and follows that tag.
% (try this when you don't remember the name of a struct field...)
public define intellipointer()
{
        variable tag;

        push_spot();
        bskip_word();
        % Get Tag
        tag = get_word();

        !if (strlen(tag)) {
                pop_spot();
                return;
        }

        @_func_top();
        bsearch_char(')');
        find_matching_delimiter('\0');

        if (match_word(tag, 1) <= 0) {
                pop_spot();
                return;
        }

        bskip_word();

        tag = get_word();
        pop_spot();
        !if (strlen(tag))
                return;

        NTags->ntags_find_tag(tag);
}

% This writes a message with the definition of variable under the cursor.
define whatis()
{
        variable size, tag, tagtype, tagdef, tagchars = "0-9A-Z_a-z\[\]\*";

        push_spot();
        bskip_word();
        % Get Tag
        tag = get_word();

%        () = read_mini("tag:", tag, "");

        !if (strlen(tag)) {
                pop_spot();
                return;
        }

        c_top_of_function();
        size = fsearch(tag);

        !if (size) {
                pop_spot();
                verror("whatis: Tag (%s) Not Found.", tag);
                return;
        }

        insert("XXXXXXXXX");
        %bskip_word();

        bskip_chars("^\{\(;");
        skip_chars(" \t\n");

        tagtype = get_word();

        skip_word();
        skip_chars("^0-9A-Z_a-z");

#ifdef VMS
        tagchars = strcat(tagchars, "$");
#endif
        bskip_chars(tagchars);
        push_mark();
        skip_chars(tagchars);
        tagdef = bufsubstr();

        pop_spot();
        !if (strlen(tagtype))
                return;

        message(">>> " + tagtype + " " + tagdef + ";");
}
%}}}
