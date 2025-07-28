link_zsh:
	ln -s $(pwd)/.zshrc $HOME/.zshrc
link_vim:
	ln -s $(pwd)/.vimrc $HOME/.vimrc
link_nvim:
	ln -s $(pwd)/append.lua $HOME/.config/nvim/append.lua
link_tmux:
	ln -s $(pwd)/.tmux.conf $HOME/.tmux.conf
