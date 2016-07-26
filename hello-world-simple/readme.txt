Fri Jun 24 08:59:47 MST 2016
----------------------------
This is the simplest possible 'hello world' on AWS.  Turns out a static
webserver is trival; S3 can serve this up directly.  You don't even need to 
rent a machine (EC2).

You must have an AWS account for this to work.  Your AWS credentials and
config must be set (check $HOME/.aws).

Edit config.txt appropriately, if you like.  All the scripts pull this in.

(typical)
make deploy	# creates 'hello world' on AWS
make test	
make clean	# unwind the changes to minimize charges

All those steps should be idempotent so if you need to re-run them it should 
just work.
