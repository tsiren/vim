cd ~/
git clone --recursive https://github.com/tsiren/vim .vim
ln -sf $HOME/.vim/vimrc $HOME/.vimrc
cd $HOME/.vim
git submodule update --init --recursive
