#!/bin/bash

PS3='Please enter your choice or press 3 to quit: '
options=("Create Troubleshooting Stack" "Delete Troubleshooting Stack" "Quit")
select opt in "${options[@]}"
do
  case $opt in
	"Create Troubleshooting Stack")
	  echo "you chose choice 1"
	  echo '-------------------------------------------------------------'
	  echo ' 	Please wait 2-5 mins until new prompt message...    	 '
	  echo '-------------------------------------------------------------'
	  aws cloudformation create-stack --stack-name troubleshoot5C2-2 --template-body "file://TRPeerConnection.yml" >/dev/null 2>&1
	  aws cloudformation wait stack-create-complete --stack-name troubleshoot5C2-2
   	  echo '-------------------------------------------------------------'
	  echo '	Setup Completed You can start the troubleshooting    	 '
	  echo '-------------------------------------------------------------'
	  echo "Below is the related information for your reference"
	  aws ec2 describe-vpcs --filters "Name=tag:Name,Values=TR-VPC*" --query "Vpcs[].{VpcId:VpcId, CidrBlock:CidrBlock, Name:Tags[?Key=='Name'] | [0].Value}" --output table
	  aws ec2 describe-instances --filters "Name=tag:Name,Values=TR-server*" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[?Tags[?Key=='Name' && starts_with(Value, 'TR-server')]].{InstanceId:InstanceId, PrivateIpAddress:PrivateIpAddress, PublicIpAddress:PublicIpAddress}" --output table
	  break
	  ;;
	"Delete Troubleshooting Stack")
	  aws cloudformation delete-stack --stack-name troubleshoot5C2-2
	  echo '-------------------------------------------------------------'
	  echo '	Deleting Troubleshooting Stack may takes 2-5 mins    	 '
	  echo '-------------------------------------------------------------'
	  break
	  ;;
	"Quit")
	  break
	  ;;
	*) echo "invalid option $REPLY";;
  esac
done
