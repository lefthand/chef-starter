#
# Cookbook Name:: starter
# Recipe:: default
#
# All rights reserved - Do Not Redistribute
#

if node[:instance_role] == 'vagrant'
  Chef::Log.warn "Looks like we're using vagrant."
end

node.set[:sysstat][:enabled] = true;
node.set[:ntp] = {
  "servers" => ["0.north-america.pool.ntp.org", "1.north-america.pool.ntp.org", "2.north-america.pool.ntp.org", "3.north-america.pool.ntp.org"]
}

# The users cookbook will setup admins in the group sysadmin.
# We make sudo users memebers of that group instead of the default admin group.
node.override[:authorization] = {
  :sudo => {
    :groups => [:sysadmin],
    :users => [:ubuntu],
    :passwordless => true
  }
}

# fqdn doesn't seem to get set on ubuntu 10.04.
if node[:fqdn]
  postfix_domain = node[:fqdn]
else
  postfix_domain = node[:hostname]
  node.set[:fqdn] = node[:hostname]
end

node.set[:postfix] = {
  :myhostname => postfix_domain,
  :smtpd_use_tls => "yes",
  :domain => true,
  :mydomain => postfix_domain,
  :aliases => {
    :bounces => "root"
  }
}

node.default[:fail2ban][:bantime] = 1200
node.default[:fail2ban][:maxretry] = 5

include_recipe "apt"
include_recipe "ntp"
include_recipe "sysstat"
include_recipe "motd-tail"
include_recipe "chef-client::delete_validation"
#include_recipe "my_hostname"
include_recipe "fail2ban"
include_recipe "postfix"

# The sudo cookbook causes problems in Vagrant.
if node[:instance_role] != 'vagrant'
  include_recipe "users::sysadmins"
  include_recipe "sudo"
end

package "curl"
package "vim"
package "tmux"
package "ncdu"
package "snmpd"
package "iftop"

# Now we can choose to restart cron in other cookbooks.
service "cron" do
  supports :restart => true
  action :nothing
end

# Now we can choose to restart ssh in other cookbooks.
service "ssh" do
  supports :restart => true
  action :nothing
end

if node[:platform] == 'ubuntu'
  # Whoopse is on by default and sends reports by default. Let's turn it off.
  template "/etc/default/whoopsie" do
    source "whoopsie.conf.erb"
    owner "root"
    group "root"
    mode 00644
  end

  # Ubuntu 13.10 handles whoopsie differently
  if node[:platform_version] == '12.04'
    service "whoopsie" do
      action [ :stop ]
    end
  end
end
