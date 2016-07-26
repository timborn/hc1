.SILENT:
.ONESHELL:

# BUCKET=hellocloud.net
# USER=hellocloud-bob
# GROUP=HelloCloud
# REGION=us-east-1
# # rule for default website URL
# # <bucket-name>.s3-website-<AWS-region>.amazonaws.com
# WEBSITE=${BUCKET}.s3-website-${REGION}.amazonaws.com
# URL=http://${WEBSITE}

include config.txt

default:
	echo targets:
	echo "	make deploy"
	echo "	make test"
	echo "	make clean"
	echo
	echo "	make install-aws-cli"

install-aws-cli:
	bash install-aws-cli.sh

clean:
	bash cleanup.sh

deploy:
	bash deploy.sh

test:	
	bash test.sh
