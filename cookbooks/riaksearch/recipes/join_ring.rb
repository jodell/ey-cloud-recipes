# Ring Related code here.
#
require 'json'
require 'net/http'
require 'resolv'
case node['name']
when "riaksearch_0"
#I shouldn't do squat here, i'm on the master node.
Chef::Log.info "I am riaksearch_0 at #{node[:ec2][:public_hostname]}"
else
#      begin
#        sleep 10
#        riak_stats = JSON.parse(`curl http://localhost:8098/stats`)
#        Net::HTTP.get_response(URI.parse('http://localhost:8098/stats')).body)
#      rescue
#        sleep 10
#        riak_stats = JSON.parse(Net::HTTP.get_response(URI.parse('http://localhost:8098/stats')).body)
#      end
  riak_utility_instance = node['utility_instances'].find {|riak| riak["name"] =~ /riaksearch_0/ }
  riak_hostname = riak_utility_instance['private_hostname'] || riak_utility_instance['hostname']


# dirty hack below cover your eyes, please pardon.
#  Chef::Log.info "I am #{node[:name]} and my /stats is #{riak_stats}"
#  ring_members = riak_stats["ring_members"]

  execute "cd /data/riak_search;bin/riaksearch-admin join riak@#{riak_hostname}" do
    action :run
#    not_if { ring_members.include?("riak@#{riak_hostname}") }
  end
end
