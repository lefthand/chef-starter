name             'starter'
maintainer       'Justin Bodeutsch'
maintainer_email 'lefthand@gmail.com'
license          'All rights reserved'
description      'Configures systems with packages and settings that are common to all nodes.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          "apt"
depends          "users"
depends          "ntp"
depends          "sudo"
depends          "sysstat"
depends          "motd-tail"
depends          "chef-client"
#depends          "my_hostname"
depends          "fail2ban"
depends          "postfix", ">= 2.1.2"

supports         "ubuntu"
