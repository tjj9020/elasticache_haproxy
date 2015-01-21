# elasticache_redis_haproxy
This is a cookbook that installs haproxy as a service and makes a call
to AWS API to find endpoints in an elasticache redis cluster.

**Assumptions:  This cookbook assumes you have compiled haproxy yourself
into a package (rpm) and placed the rpm into your own yum repository.**

## Targeted Operating Systems ##
CentOS 6/7

## Usage ##
This cookbook assumes that it will get authentication through AWS EC2
Instance Roles.

put `elasticache_haproxy::default` in your run list
