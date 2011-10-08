# click.click.moon's ~/.bashrc

# Kill non-interactive sessions and start tmux
[[ $- != *i* ]] && return
[[ $TERM != "screen" ]] && tmux list-sessions

# start ssh-agent
eval `ssh-agent`

# Show a random custom cowfile with an obsense fortune
cowfile=`ls ~/cowfiles/*.cow | sort -R | tail -1`
command cowsay -f $cowfile $(fortune -o)

export EDITOR="vim"

# COLORS (Got Tired Of Escapes)
Color_Off='\e[0m'
Green='\e[0;32m'
Yellow='\e[0;33m'
Blue='\e[0;34m'
Purple='\e[0;35m'
White='\e[0;37m'
On_Red='\e[41m'
On_White='\e[47m'

# Allow sudo aliases to work
alias sudo='A=`alias` sudo '

# ls aliases that I like a lot
alias ls='ls --color=auto'
alias lr='ls -R'
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX' # Sort: eXtension
alias lz='ll -rS' # Sort: siZe
alias lt='ll -rt' # Sort: daTe

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Rainbo Brite up my shit
alias diff='colordiff'
alias grep='grep --color=auto'
alias more='less'
alias pacman='pacman-color'

# Autocomplete man and sudo commands
complete -cf sudo
complete -cf man

# Simple git repo state output that fits nicely in a prompt -click
# TODO: This is prolly not the best way to do this and the long
# strings could be make more readable. -click
function gitline {
	local git_branch=$( git name-rev HEAD 2> /dev/null | sed 's/HEAD\ \(.\)/\1/' )
	local git_version=$( git show --abbrev-commit --abbrev=8 2> /dev/null| sed -n 's/^commit\ \(.\{8\}\)/\1/p' )
	local git_status=$( git status 2> /dev/null )
	local git_staged=$( echo "$git_status" | sed -n 's/# Changes to be committed:/S/p' )
	local git_modified=$( echo "$git_status" | sed -n 's/# Changes not staged for commit:/M/p' )
	local git_unmerged=$( echo "$git_status" | sed -n 's/# Unmerged paths:/M/p' )
	local git_untracked=$( echo "$git_status" | sed -n 's/# Untracked files:/U/p' )

	if [ "$git_branch" == "" ]; then
		echo -en " ${White}${On_Red}unversioned${Color_Off}"
	else
		echo -en " [git:${Red}"$git_branch"${Color_Off}:${Yellow}"$git_version"${Color_Off}]${Green}$git_staged${Color_Off}${Purple}${On_White}$git_modified${Color_Off}${White}${On_Red}$git_unmerged${Color_Off}${Blue}${On_White}$git_untracked${Color_Off}"
	fi
}

# Time it so you know how bad it is
function test_gitline {
    local i=0
    while [ $i -le 100 ]; do
            gitline
            i=$(expr $i + 1)
    done
}


# Time the timer
function test_test {
        local i=0
        while [ $i -le 100 ]; do
                i=$(expr $i + 1)
        done
}

# I can barely read this but it's so sexy in a console
# TODO: Figure out how this can be made readable. -click
PROMPT_COMMAND='echo -en "\n";history -a;echo -en "\033[m\033[38;5;2m"$(( `sed -nu "s/MemFree:[\t ]\+\([0-9]\+\) kB/\1/p" /proc/meminfo`/1024))"\033[38;5;22m/"$((`sed -nu "s/MemTotal:[\t ]\+\([0-9]\+\) kB/\1/Ip" /proc/meminfo`/1024 ))MB"\t\033[m\033[38;5;55m$(< /proc/loadavg)\033[m";echo -en "$(gitline)"'
PS1='\[\e[m\n\e[1;30m\][$$:$PPID \j:\!\[\e[1;30m\]]\[\e[0;36m\] \T \d \[\e[1;30m\][\[\e[1;34m\]\u@\H\[\e[1;30m\]:\[\e[0;37m\]${SSH_TTY} \[\e[0;32m\]+${SHLVL}\[\e[1;30m\]] \[\e[1;37m\]\w\[\e[0;37m\] \n($SHLVL:\!)\$ '
 
