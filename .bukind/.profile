
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ "$(uname -m)" = 'x86_64' ] ; then
    lib="lib64"
else
    lib="lib"
fi
if [ -d "$HOME/$lib" ] ; then
    if [ -n "${LD_LIBRARY_PATH}" ] ; then
        LD_LIBRARY_PATH="$HOME/$lib:$LD_LIBRARY_PATH"
    else
        LD_LIBRARY_PATH="$HOME/$lib"
    fi
    export LD_LIBRARY_PATH
fi
unset lib

LESS='-i -R -j 5 -P %lt'
export LESS
unset LC_ALL
LANG=ru_RU.UTF-8
LC_MESSAGES=en_US.UTF-8
LC_NUMERIC=en_US.UTF-8
export LANG LC_MESSAGES LC_NUMERIC
if [ -x /usr/bin/jed ]; then
    export EDITOR=/usr/bin/jed
fi

if [ -d $HOME/install/jed/jed ]; then
    export JED_ROOT="$HOME/install/jed/jed"
fi

if [ -f $HOME/.local/.bash_profile ] ; then
    source $HOME/.local/.bash_profile
fi

if [ -d $HOME/devel/golang ]; then
    export GOPATH=$HOME/devel/golang
    export PATH=$PATH:$GOPATH/bin
fi
