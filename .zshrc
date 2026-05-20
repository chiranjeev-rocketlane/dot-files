# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="jonathan"
  # ZSH_THEME="agnoster"
  # ZSH_THEME=random

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
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
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#
#

# --- CUSTOM HYBRID POWERLINE PROMPT (AESTHETIC) ---

build_prompt() {
  # 1. Softer, eye-pleasing colors (Rosé Pine / Bamboo inspired)
  local bg_colors=("#f6c177" "#eb6f92" "#9ccfd8" "#c4a7e7") # Soft Gold, Rose, Cyan, Iris
  local fg_colors=("black" "black" "black" "black")
  local line_color="#6e6a86" # Muted grey for the Jonathan structural lines
  
  # Git Colors: Soft Green background, Black text
  local bg_git="#a6e3a1"
  local fg_git="black"
  
  # Top Line: Starts with the Jonathan curve
  local top_line="%F{$line_color}╭─%f"
  local current_path=${PWD/#$HOME/\~}
  
  # 2. Path Splitting and Coloring
  if [[ "$current_path" == "/" ]]; then
    top_line+="%K{${bg_colors[1]}}%F{${fg_colors[1]}} / %k%f"
    top_line+="%F{${bg_colors[1]}}%f"
  else
    local paths=("${(@s:/:)current_path}")
    local c=1
    local prev_bg=""

    for p in "${paths[@]}"; do
      if [[ -n "$p" ]]; then
        local current_bg="${bg_colors[$c]}"
        local current_fg="${fg_colors[$c]}"
        
        # Draw the seamless triangle transition
        if [[ -n "$prev_bg" ]]; then
          top_line+="%K{$current_bg}%F{$prev_bg}%k%f"
        fi
        
        top_line+="%K{$current_bg}%F{$current_fg} $p %k%f"
        prev_bg="$current_bg"
        
        # Cycle to the next color in the array
        ((c = c % ${#bg_colors[@]} + 1))
      fi
    done
    
    # 3. Git Integration (Appended to the end of the path)
    local git_info="$(git_prompt_info)"
    if [[ -n "$git_info" ]]; then
      ZSH_THEME_GIT_PROMPT_PREFIX="  "
      ZSH_THEME_GIT_PROMPT_SUFFIX=" "
      ZSH_THEME_GIT_PROMPT_DIRTY=" [!]"
      ZSH_THEME_GIT_PROMPT_CLEAN=" [✔]"
      
      top_line+="%K{$bg_git}%F{$prev_bg}%k%f"
      top_line+="%K{$bg_git}%F{$fg_git}${git_info}%k%f"
      top_line+="%F{$bg_git}%f"
    else
      # Cap off the end of the path if not in a Git repo
      top_line+="%F{$prev_bg}%f"
    fi
  fi

  # 4. Bottom Line: Jonathan curve + Rocketlane double arrow (Black & Blue)
  # Using a vibrant royal blue for the second arrow
  local bottom_line="%F{$line_color}╰─%f %F{#000000}❯%f%F{#2b6aff}❯%f "

  # 5. Combine Top and Bottom lines
  PROMPT="${top_line}
${bottom_line}"
}

# Clear right prompt
RPROMPT=""

# Attach function to run before every command prompt
precmd_functions+=(build_prompt)
