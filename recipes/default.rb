#
# Cookbook Name:: gbg_family_finder::_haproxy
# Recipe:: default
#
# Copyright 2014, Gene by Gene
#
# All rights reserved - Do Not Redistribute
#

extend Amazon::Helpers

group "haproxy" do
  gid 8001
  action :create
end

user "haproxy" do
  uid 8001
  gid 8001
  shell "/bin/nologin"
  action :create
end

#This assumes you have compiled haproxy into 1.5.9 or later and placed it into your own yum repo
#fpm is a great tool for making rpms: https://github.com/jordansissel/fpm/wiki
package "haproxy" do
  action :install
end

directory "/etc/ssl" do
  action :create
end

cookbook_file "/etc/init.d/haproxy" do
    source = "haproxy"
    mode "0755"
    owner = "root"
    group = "root"
    action :create
end

link '/etc/rc.d/rc3.d/S92haproxy' do
  to '/etc/init.d/haproxy'
end

link '/etc/rc.d/rc5.d/S92haproxy' do
  to '/etc/init.d/haproxy'
end

link '/etc/rc.d/rc3.d/K92haproxy' do
  to '/etc/init.d/haproxy'
end

link '/etc/rc.d/rc5.d/K92haproxy' do
  to '/etc/init.d/haproxy'
end

service "haproxy" do
  action :enable 
end

directory "/etc/haproxy" do
  action :create
end

#Get define and get elasticache redis cluster endpoint
endpoints = get_read_endpoints(node['elasticache_haproxy']['cluster_name'])
Chef::Log.info(endpoints.to_s)

template "/etc/haproxy/haproxy.cfg" do
  source = "haproxy.cfg.erb"
  owner = 'root'
  group = 'root'
  mode "0755"
  variables(:servers => endpoints,
            :haproxy_admin_user => node['elasticache_haproxy']['haproxy_admin_user'],
            :haproxy_admin_password => node['elasticache_haproxy']['haproxy_admin_password']
           )
  action :create
  notifies :reload, resources(:service => "haproxy")
end 

service "haproxy" do
  action [ :start, :enable ]
end
