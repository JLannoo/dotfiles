# Dotfiles and setup bootstrap script
This is a minimal bootstrap script for setting up my dotfiles repository on a new machine.  
Mainly intended to be run via `curl` and `bash` as described in the comments of the `scripts/setup.sh` file.  

Probably only works on Ubuntu based systems for now.

## Usage
To run the setup script, execute the following command in your terminal:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jlannoo/dotfiles/master/scripts/setup.sh)"
```
You can also enable automatic installation of additional software and dotfiles by setting environment variables:
```bash
AUTO_INSTALL_MORE=y AUTO_SETUP_DOTFILES=y bash -c "$(curl -fsSL https://raw.githubusercontent.com/jlannoo/dotfiles/master/scripts/setup.sh)"
```
