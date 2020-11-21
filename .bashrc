# Shell is non-interactive.  Be done now!
if [[ $- != *i* ]] ; then
	return
fi

# Install starship prompt if it's not already installed
if ! command -v starship &> /dev/null; then
	curl -fsSL https://starship.rs/install.sh | bash
fi

# Install z.sh for easy directory navigation
if ! test -f ~/.config/z.sh; then
	curl https://github.com/rupa/z/raw/master/z.sh --output ~/.config/z.sh
fi

# Source z.sh to enable it
. ~/.config/z.sh

if ! test -f ~/.fzf/install; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
fi

# source fuzzy find to enable it
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Enable vi mode
set -o vi

# Set Prompt
eval "$(starship init bash)"

# PATH Variable
export PATH=$PATH:~/.local/bin:~/projects/go/bin:~/.cargo/bin

### Functions
edit ()
{
	if command -v vim &> /dev/null; then
		vim "$@"
	elif command -v nvim &> /dev/null; then
		nvim "$@"
	elif command -v vi &> /dev/null; then
		vi "$@"
	else
		nano "$@"
	fi
}

sedit ()
{
	if command -v vim &> /dev/null; then
		sudo vim "$@"
	elif command -v nvim &> /dev/null; then
		sudo nvim "$@"
	elif command -v vi &> /dev/null; then
		sudo vi "$@"
	else
		sudo nano "$@"
	fi
}

# Extracts any archive(s) (if unp isn't installed)
extract () {
	for archive in $*; do
		if [ -f $archive ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Searches for text in all files in the current folder
ftext ()
{
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp()
{
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
		| awk '{
			count += $NF
			if (count % 10 == 0) {
				percent = count / total_size * 100
				printf "%3d%% [", percent
				for (i=0;i<=percent;i++)
					printf "="
					printf ">"
					for (i=percent;i<100;i++)
						printf " "
						printf "]\r"
					}
			}
		END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
	}

# Copy and go to the directory
cpg ()
{
	if [ -d "$2" ];then
		cp $1 $2 && cd $2
	else
		cp $1 $2
	fi
}

# Move and go to the directory
mvg ()
{
	if [ -d "$2" ];then
		mv $1 $2 && cd $2
	else
		mv $1 $2
	fi
}

# Create and go to the directory
mkdirg ()
{
	mkdir -p $1
	cd $1
}

# Goes up a specified number of directories  (i.e. up 4)
up ()
{
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
	do
		d=$d/..
	done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

# Show current network information
netinfo ()
{
	echo "--------------- Network Information ---------------"
	ifconfig | grep -v 127.0.0.1 | awk /'inet / {print $2}'
	ifconfig | grep -v 127.0.0.1 | awk /'inet / {print $4}'
	ifconfig | grep -v 127.0.0.1 | awk /'inet / {print $6}'
	ifconfig | awk /'ether / {print $2}'
	echo "---------------------------------------------------"
}

# Trim leading and trailing spaces (for scripts)
trim()
{
	local var=$@
	var="${var#"${var%%[![:space:]]*}"}"  # remove leading whitespace characters
	var="${var%"${var##*[![:space:]]}"}"  # remove trailing whitespace characters
	echo -n "$var"
}

if command -v vim &> /dev/null; then
	export EDITOR=vim
fi


##### Exports
# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Language
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8
export GOPATH=$HOME/projects
export TERM=xterm-256color

### My Alaises
alias dvk="sudo loadkeys dvorak"
alias emu="emerge --ask --update --deep --with-bdeps=y --newuse @world"
alias pico='edit'
alias spico='sedit'
alias nano='edit'
alias snano='sedit'
alias svim='sedit'
alias svi='sudo edit'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -iv'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 4'
alias less='less -R'
alias cls='clear'
alias yum='sudo yum'
alias apt='sudo apt'
alias aptu='sudo apt update && sudo apt upgrade -y'
alias emerge='sudo emerge'
alias equery='sudo equery'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias bd='cd "$OLDPWD"' # CD into previous PWD
alias rmd='/bin/rm  --recursive --force --verbose ' # Remove a directory and all files
alias la='ls -Alh' # show hidden files
alias ls='ls -aFh --color=auto' # add colors and file type extensions
# alias ls='exa -a' # add colors and file type extensions
# alias ll='exa -la' # long listing format
alias ll='ls -Fls --color=auto' # long listing format
alias lx='ls -lXBh --color=auto' # sort by extension
alias lk='ls -lSrh --color=auto' # sort by size
alias lc='ls -lcrh --color=auto' # sort by change time
alias lu='ls -lurh --color=auto' # sort by access time
alias lr='ls -lRh --color=auto' # recursive ls
alias lt='ls -ltrh --color=auto' # sort by date
alias lm='ls -alh --color=auto |more' # pipe through 'more'
alias lw='ls -xAh --color=auto' # wide listing format
alias labc='ls -lap --color=auto' #alphabetical sort
alias lf="ls -l --color=auto | egrep -v '^d'" # files only
alias ldir="ls -l --color=auto | egrep '^d'" # directories only
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'
alias h="history | grep " # Search command line history
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias f="find . | grep "
# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"
alias checkcommand="whence -w" # To see if a command is aliased, a file, or a built-in command
alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'" # Show current network connections to the server
alias openports='netstat -nape --inet' # Show open ports
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias cdscripts="cd '/mnt/c/Users/nowen/OneDrive/Desktop/original/Profile/work/scripts'"
alias add='git add -A'
alias status='git status'
alias commit='git commit -m'
alias pushd='git push origin dev'
alias pushq='git push origin qa'
alias pushm='git push origin master'
alias pull='git pull'
alias log='git log'
alias reset='git reset --hard'
alias aedit='ansible-vault edit'
alias cdopensystems='cd ~/opensystems_ansible'
alias cdansible='cd ~/opensystems_ansible'
alias arkmanager='sudo -u steamcmd arkmanager'
alias connections='sudo netstat -vaut'
alias python="python3"
alias batterys="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias eselect="sudo eselect"
