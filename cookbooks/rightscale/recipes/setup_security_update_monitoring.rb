#
# Cookbook Name:: rightscale
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements
# such as a RightScale Master Subscription Agreement.

rightscale_marker

# Load the exec plugin in the main config file
# See cookbooks/rightscale/definitions/rightscale_enable_collectd_plugin.rb
# for the "rightscale_enable_collectd_plugin" definition.
rightscale_enable_collectd_plugin "exec"

# See cookbooks/rightscale/recipes/setup_monitoring.rb for the
# "rightscale::setup_monitoring" recipe.
include_recipe "rightscale::setup_monitoring"

# The package to be installed to obtain information about
# updates/security updates
package_to_install =
  case node[:platform]
  when "ubuntu"
    "update-notifier-common"
  else
    "yum-security"
  end

package package_to_install

log "  Install security monitoring package dependencies and plugin"
# Install custom collectd plugin
directory ::File.join(node[:rightscale][:collectd_lib], "plugins") do
  recursive true
  action :create
end

cookbook_file ::File.join(
  node[:rightscale][:collectd_lib],
  "plugins",
  "update_monitor"
) do
  source "update_monitor_collectd_plugin.rb"
  mode 0755
  notifies :restart, resources(:service => "collectd")
end

template ::File.join(
  node[:rightscale][:collectd_plugin_dir],
  "update_monitor.conf"
) do
  source "update_monitor.conf.erb"
  variables(
    :collectd_lib => node[:rightscale][:collectd_lib],
    :server_uuid => node[:rightscale][:instance_uuid]
  )
  mode 0644
end
