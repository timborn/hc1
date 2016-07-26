source config.txt

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

