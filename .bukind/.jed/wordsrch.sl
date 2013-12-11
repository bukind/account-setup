%
% Word Search
% simple whole-word search functions
%
% Written by Dino Leonardo Sangoi (Saurus) <g1001863@univ.trieste.it>
%
% My Bindings are:
%   ^FW  : search_word(1)
%   ^F^W : search_word(-1)
%   ^FC  : search_change_case
%
% You may also bind a key to generic_search(), and another to
% search_change_wholeword()
%
implements("WordSearch");

require("srchmisc");

static variable SearchLen = 0;
static variable WholeWordSearch = 0;

static define _check_match()
{
        variable Sleft, Sright;

        push_spot();
        Sleft = bolp();
        go_left_1();
        if (Sleft == 0)
                Sleft = re_looking_at("[^a-zA-Z0-9_]");
        go_right(SearchLen+1);
        Sright = eolp();
        if (Sright == 0)
                Sright = re_looking_at("[^a-zA-Z0-9_]");
        pop_spot();
        return ((Sleft > 0) and (Sright > 0));
}

static define search_one_word(str, dir)
{
        variable l;
        if (dir > 0)
                l = fsearch(str);
        else
                l = bsearch(str);
        % Grrr, search_maybe_again wants negative numbers as error
        if (l == 0)
                l = -1;
        return l;
}

static define find_one_word(str, dir)
{
        variable l;
        if (dir > 0)
                return ffind(str);
        else
                return bfind(str);
        return l;
}

% Get the word under the cursor (a lot C programming oriented, I would like to
% rely on word_chars definitions, but lots of times it misses '_'
public define get_word()
{
        variable word = "0-9A-Z_a-z";
#ifdef VMS
        word = strcat(tag, "$");
#endif
        push_spot();
        bskip_chars(word);
        push_mark();
        skip_chars(word);
        bufsubstr();   % Leave on stack
        pop_spot();
        % return value on stack
}

% Ask user for word to search.
public define search_word(dir)
{
        variable str;

        "Search Word ";
        if (dir > 0)
                "Forward:";
        else
                "Backward:";
        str = read_mini(()+(), LAST_SEARCH, "");
        if (strlen(str) == 0)
                return;

        LAST_SEARCH = str;
        SearchLen = strlen(str);

        push_mark();
        if (not (search_maybe_again(&search_one_word, str, dir, &_check_match))) {
                pop_mark_1;
                verror ("%s: not found.", str);
        }
        pop_mark_0;
}

% Match next or prev word, for use by scripts (doesn't need user input).
public define match_word(str, dir)
{
        variable len;

        SearchLen = strlen(str);
        while (len = search_one_word(str, dir), len > 0)
        {
                if (_check_match())
                        break;
                if (dir > 0)
                        go_right_1();
        }
        return len;
}

% Find next or prev word, on current line. For use by scripts (doesn't need user input).
public define find_word(str, dir)
{
        variable len;

        SearchLen = strlen(str);
        while (len = find_one_word(str, dir), len > 0)
        {
                if (_check_match())
                        break;
                if (dir > 0)
                        go_right_1();
        }
        return len;
}

% Helper function to change CASE_SEARCH
public define search_change_case()
{
        if (CASE_SEARCH == 0) {
                CASE_SEARCH = 1;
                message("Case search set to ON.");
        } else {
                CASE_SEARCH = 0;
                message("Case search set to OFF.");
        }
}

public define search_change_wholeword()
{
        if (WholeWordSearch == 0) {
                WholeWordSearch = 1;
                message("Whole word search set to ON.");
        } else {
                WholeWordSearch = 0;
                message("Whole word search set to OFF.");
        }
}

public define generic_search(dir)
{

        if (LAST_SEARCH == "")
                LAST_SEARCH = get_word();

        if (WholeWordSearch == 0) {
                if (dir > 0)
                        search_forward();
                else
                        search_backward();
        } else
                search_word(dir);
}

provide("wordsrch");
