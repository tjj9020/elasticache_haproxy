#The purpose of the helper is to get a list of redis servers running in elasticache
#so we can put the end points into an haproxy configuration file.  This allows us to 
#scale our redis cluster up and down without having to manually change our haproxy configuration file.
#
#
module Amazon
  module Helpers

    def get_read_endpoints(cluster_name)
      #Check to make sure the amazon sdk is installed into chef's ruby
      #This is not a perfect way of installing the sdk but it works
      begin
        gem "aws-sdk"
      rescue LoadError
        system("yum install -y ruby-devel libxml2 tar gzip gcc patch make automake zlib-devel; gem install --no-rdoc --no-ri aws-sdk")
        Gem.clear_paths
      end
       
      #We assume and EC2 instance role for authentication into elasticache
      #See amazon documentation for ec2 instance roles
      require 'yaml'
      require 'aws-sdk'

      ec = AWS::ElastiCache.new

      #Get cluster id using redis cluster name defined in attributes
      cluster = ec.client.describe_replication_groups(options = {:replication_group_id=>"#{cluster_name}"})

      #loop through json
      read_endpoints = []
        cluster.fetch(:replication_groups, []).each do |rg|
          rg.fetch(:node_groups, []).each do |ng|
            ng.fetch(:node_group_members, []).each do |ngm|
              read_endpoints << ngm.fetch(:read_endpoint, nil)
            end
          end
        end

      #return all the endpoints of your redis cluster
      read_endpoints

    end
  end
end
