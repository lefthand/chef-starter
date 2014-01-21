<<<<<<< HEAD
# starter cookbook

Includes cookbooks:

- apt
- motd-tail
- chef-client (deletes validation key)
- users
- sudo
- hostname

Installs the following packages:

- ntp
- fail2ban
- postfix
- sysstat
- curl
- vim
- tmux
- ncdu
- iftop

# Requirements

Tested against Ubuntu 12.04 and 13.10

# Usage

Put this cookbook first in the run list of every node in your network. 

# Attributes

# Recipes

Only the default recipe.

# Author

Author:: Justin Bodeutsch (<lefthand@gmail.com>)
