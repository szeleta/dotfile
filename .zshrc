PROMPT='%D{%Y/%m/%d %H:%M:%S} %/
%n %# '

precmd () {print ""}


export HISTFILE=${HOME}/.history
# メモリに保存される履歴の件数
export HISTSIZE=10000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=1000000
# 文字コードの指定
export LANG=ja_JP.UTF-8
# 重複を記録しない
setopt hist_ignore_dups
# これでtmuxでも履歴が共有できるらしい
setopt share_history
# 開始と終了を記録
setopt EXTENDED_HISTORY
# 何の設定か忘れた
setopt auto_cd
setopt nobeep

autoload -U compinit

compinit

# 大文字小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# alias
alias ls='ls --color=auto -G'
alias ll='ls --color=auto -CFGl'
alias la='ls --color=auto -CFGla'

alias relog='exec $SHELL -l'

#alias yomitan='ssh yomitan -4'

alias juno="jupyter-lab"
