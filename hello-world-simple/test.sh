source config.txt

# rule for default website URL
# <bucket-name>.s3-website-<AWS-region>.amazonaws.com
WEBSITE=$BUCKET.s3-website-$REGION.amazonaws.com
URL=http://$WEBSITE

curl -sSf ${URL} > /dev/null 2>&1 		
[ $? != 0 ] && echo "Unable to view website=${URL}" && exit -1 
curl -sSf ${URL}/random > /dev/null 2>&1 	
[ $? != 22 ] && echo "Error handling failed" && exit -1	

# normally I like "silence is golden", but in this case a little reassurance
echo "All Tests Pass (ATP)"
exit 0
