#!/bin/bash

# Get the instance IDs of EKS nodes
INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=tag:aws:eks:cluster-name,Values=<eks-cilium>" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Iterate over each instance ID and flush iptables rules
for INSTANCE_ID in $INSTANCE_IDS; do
  aws ssm send-command --instance-ids $INSTANCE_ID --document-name "AWS-RunShellScript" --comment "Flush iptables rules added by VPC CNI" --parameters 'commands=["sudo iptables -t nat -F AWS-SNAT-CHAIN-0", "sudo iptables -t nat -F AWS-SNAT-CHAIN-1", "sudo iptables -t nat -F AWS-CONNMARK-CHAIN-0", "sudo iptables -t nat -F AWS-CONNMARK-CHAIN-1"]'
done

