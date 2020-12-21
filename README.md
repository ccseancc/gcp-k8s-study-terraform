# gcp-k8s-study-terraform

## Purpose
This repository contains common modules which can be used to create a network, subnet, instance, managed instance groups, kubernetes cluster etc.
The provisioned infrastructure are self managed kubernetes cluster with 1 master, and 2 workers nodes. It can be used for self study, and as the preparation for CKA exam. 

## Prerequisite:
Google Cloud Platform account is required, you may sign up an new account and get $300 free credit.

## Cluster Details
* Control plane	: control0
* Worker node: node0, node1
* OS: Ubuntu 					## This is to align with CKA exam environment
* Container Runtime : Docker
* CNI : Calico
* VPC: 10.210.0.0/16
* Pod CIDR : 10.200.0.0/16
* Load Balancer: external Load balancer is used so that we can adding control plane node to provide high availability 


## Steps to provision the self managed kubernetes cluster:

1. Setup the Google Cloud SDK

2. Git clone the repository and edit following files
```
cp terraform.tfvars.example terraform.tfvars
edit file terraform.tfvars
```
3. Provision the infrastructure using terraform
```
terraform init
terraform plan
terraform apply
```
4. Use the scripts to setup the K8s:

a) Natvigate the scripts directory
```
cd ~/gcp-k8s-study-terraform/scripts
```
b) setup the master node
```	
sh -x k8s_master0-setup.sh
```
c) setup the worker nodes
```	
sh -x k8s_worker-setup.sh node0
sh -x k8s_worker-setup.sh node1
```
### Remarks:
To destroy the terraform objects, run :
```
terraform destroy
```


