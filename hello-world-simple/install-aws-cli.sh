# install AWS CLI
# http://docs.aws.amazon.com/cli/latest/userguide/installing.html#install-bundle-other-oa	

if [ `uname -s` == "Darwin" ] ; then	
	which aws > /dev/null 2>&1	
	if [ $? != 0 ] ; then 		
		 curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" 
		unzip awscli-bundle.zip	
		./awscli-bundle/install -b ~/bin/aws	
		echo $PATH | grep -q ~/bin > /dev/null 2>&1	
		if [ $? != 0 ] ; then	
			echo "add the following to ~/.bash_profile:" 
			echo "export PATH=~/bin:\$PATH"	
		fi	
	fi
else 
	echo "installation instructions for AWS CLI are found here:"
	echo "http://docs.aws.amazon.com/cli/latest/userguide/installing.html#install-bundle-other-oa"
fi

