#!/bin/bash
set +x
if [ $# -gt 0 ]; then
    for REGION in $*; do
        cowsay "[#-------${REGION}-------#]"
        aws ec2 describe-vpcs --region $REGION | jq ".Vpcs[].VpcId" -r
    done
else
    cowsay "You Have Given $# paramters to this script, please provide arg Eg.us-east-1."
fi
fi
fi


