# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


[ -r ~/.checkOS ] && [ -f ~/.checkOS ] && source ~/.checkOS;

# Path to your oh-my-zsh installation.
case "$(uname -s)" in

   Darwin)
     export ZSH=/Users/ericschanet/.oh-my-zsh
     ;;

   Linux)
     if [[ "$LXPLUS" == "0" ]]
     then
       export ZSH=/home/e/Eric.Schanet/.oh-my-zsh
     else
       export ZSH=/afs/cern.ch/user/e/eschanet/.oh-my-zsh
     fi

     ;;

   CYGWIN*|MINGW32*|MSYS*)
     echo 'MS Windows'
     ;;

   # Add here more strings to compare
   # See correspondence table at the bottom of this answer

   *)
     echo 'other OS'
     ;;
esac

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

ZSH_THEME="robbyrussell"
DEFAULT_USER=`whoami`
# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# redefine prompt_context for hiding user@hostname
#prompt_context () { }

[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

#define all the necessary env variables as well as aliases
if [[ "$LINUX" == "1" ]]
then
  if ! [[ "$dist_info" == 'slc' ]]
  then
  	source /etc/profile.d/modules.sh 2> /dev/null
  	module load root/6.18.04 2> /dev/null

	fi
  for file in ~/.{path,exports,aliases,functions}; do
		[ -r "$file" ] && [ -f "$file" ] && source "$file";
	done;
	unset file;
elif [[ "$OSX" == "1" ]]
then
  for file in ~/.{path,exports,aliases,functions}; do
		[ -r "$file" ] && [ -f "$file" ] && source "$file";
	done;
	unset file;
fi

#SLC6 for work station gar-ws-etp06
if [[ "$LINUX" == "1" ]]
then
  if [[ "$LXPLUS" == "0" ]]
  then
    source /project/etpsw/Common/bin/setup_image.sh
  fi
  if [[ "$dist_info" == 'slc' ]]
  then
  		if [ -n "$ZSH_VERSION" ]
  		then
  				PROMPT=$(awk '!x{x=sub(" "," %{$fg_bold[white]%}(${dist_info}) ")}7' <<< $PROMPT)
  		fi
  fi
fi

#BASE16 colors
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# This is causing some errors, and I have no idea why it should be here in the first place?
# if [ -d /etc/profile.d ]; then
#   for i in /etc/profile.d/*.sh; do
#     if [ -r $i ]; then
#       . $i
#     fi
#   done
#   unset i
# fi


# Different autocompletion order for cd (by inverse modification date)
zstyle ':completion:*:cd:*' file-sort modification

. ~/dotfiles/z.sh

# weird z.sh bug: https://github.com/robbyrussell/oh-my-zsh/issues/7094
if [ "$_Z_NO_RESOLVE_SYMLINKS" ]; then
    _z_precmd() {
        (_z --add "${PWD:a}" &)
        : $RANDOM
    }
else
    _z_precmd() {
        (_z --add "${PWD:A}" &)
        : $RANDOM
    }
fi
