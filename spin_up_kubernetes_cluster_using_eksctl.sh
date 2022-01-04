#!/bin/bash
### you can spin up the kubernetes cluster on AWS using multipal options like AWS CLI, cloudformation, eksctl CLI ###
### in this example we will create cluster using eksctl cli ###
### please instal amazon cdk before installation ###


# creat EKS cluster with one nodegroup containing 2 m5.large nodes
eksctl create cluster

# create EKS cluster with k8 version "version number" with 2 t3.micro nodes
eksctl create cluster --name <name> --version <1.21> --node-type t3.micro --node 2

# cretae a EKS cluster with managed node group
eksctl create cluster --name <name> --version <1.21> --nodegroup-name <name> --node-type t3.micro --nodes 2 --managed

# to check the workload running on the cluster
kubectl get pods --all-namespaces -o wide