# Dotfiles

These are my user dotfiles.
The repository configuration was taken from [https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/](here).

## Instructions

To create a repo such as this:

* `git init $HOME/.cfg`
* Create the alias `alias config='/usr/bin/git --git-dir=$HOME/.cfg/.git -- work-tree=$HOME'`
* With the alias, run `config config --local statys.showUntrackedFiles no`
* Setup the repository to track a remote and use `config` command instead of `git` to manage it.

To install this repo:

* `echo ".cfg" >> .gitignore`
* `git clone https://github.com/Caioflp/dotfiles.git $HOME/.cfg`
* Create the alias `alias config='/usr/bin/git --git-dir=$HOME/.cfg/.git -- work-tree=$HOME'`
* `config config --local status.showUntrackedFiles no`
* `config checkout`
