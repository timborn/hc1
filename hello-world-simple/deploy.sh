# assumes you have AWS CLI working and configured
# which implies you have signed up for an AWS account
# NB the USER you are running as should not be the USER you delete
# or this script runs out of permissions before it finishes

source config.txt

### does AWS CLI really work?
aws s3 ls > /dev/null 2>&1
retval=$?
if [ $retval != 0 ] ; then 
	echo "you need to get AWS CLI working first before you can proceed"
	exit -1
fi

### Create an IAM User
### Create an IAM Group
### Place User In Group (why?)
### Generate Keys For User and Update AWS CLI Configuration
### At This Point We Can Start Working On The Website
### Create Buckets For Your Website (S3)
aws s3 mb s3://$BUCKET  > /dev/null 2>&1
if [ $? != 0 ] ; then 
	echo "Unable to create S3 bucket=$BUCKET"
	exit -1
fi

### Add Permissions For Buckets (so people can read files on website)
aws s3api put-bucket-policy --bucket $BUCKET --policy file://policy.txt

# policy.txt:
# {
# 	"Statement":[
# 	    {
# 		"Sid":"Allow Public Access to All Objects",
# 		"Effect":"Allow",
# 		"Principal":"*",
# 		"Action":"s3:GetObject",
# 		"Resource":"arn:aws:s3:::$BUCKET/*"
# 	    }
# 	]
# }


### Create Local Copy Of Website

### Deploy Website / Upload Files To Bucket
aws s3 cp index.html s3://$BUCKET
aws s3 cp error.html s3://$BUCKET
# aws s3 cp index.html s3://$BUCKET --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
# aws s3 cp error.html s3://$BUCKET --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

### Configure Bucket As A Website
aws s3 website s3://$BUCKET --index-document index.html --error-document error.html

### Test Website
echo "Your website is at $WEBSITE."
echo "Test it now.  Run cleanup when done."
exit 0

### CLEANUP

### Delete Website Bucket
aws s3 rb s3://$BUCKET --force > /dev/null 2>&1
retval=$?
if [ $retval != 0 ] ; then
	aws s3 ls $BUCKET >/dev/null 2>&1
	if [ $? == 0 ] ; then
		echo failed to removed bucket "$BUCKET"; is the bucket versioned?
		exit -1
	fi
fi

### Delete IAM User From IAM Group (must precede deletion of user)
aws iam remove-user-from-group --user-name $USER --group-name $GROUP >/dev/null 2>&1
retval=$?
if [ $retval != 0 ] ; then
	# may have already been removed from the group
	aws iam list-groups-for-user --user-name $USER 2>&1 | grep -q $GROUP
	if [ $? == 0 ] ; then 
		echo "Unable to remove user=$USER from group=$GROUP"
		exit -1
	fi
fi

### Delete IAM User
aws iam delete-user --user-name $USER >/dev/null 2>&1
# if [ $? != 0 ] ; then
# 	echo "Unable to delete user=$USER"
# 	exit -1
# fi
# we like idempotent, so ignore the case where $USER may already be gone

### Delete IAM Group -- but only if it is empty?
# won't delete if group is still in use, so just carry on
aws iam delete-group --group-name $GROUP >/dev/null 2>&1

### Invalidate Keys
aws iam list-access-keys --username $USER > /dev/null 2>&1
if [ $? == 0 ] ; then
	echo "Somehow the keys for user=$USER remain.  Invalidate them now."
	exit -1
fi

