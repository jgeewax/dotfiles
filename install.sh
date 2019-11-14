# Copy all the dotfiles into the home directory.
cp .bash-powerline.sh ~/
cp .bash_aliases ~/
cp .bashrc ~/
cp .curlrc ~/
cp .editorconfig ~/
cp .gitconfig ~/
cp .gitignore ~/
cp .tmux.conf ~/
cp .vimrc ~/

# Install vim pathogen.
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install NVM.
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

# Make NVM work now.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install the important Node versions.
nvm install 10
nvm install 13
nvm install latest
nvm alias stable 10

# Append authorized keys to any that we have locally.
mkdir -p ~/.ssh
cat .ssh/authorized_keys >> ~/.ssh/authorized_keys
