#!/bin/bash

source cmsset

# make your mother directory
mkdir test_01
cd test_01

# scram list : cmssw version search
# We will install CMSSW_9_3_2
# cmsrel "version you want" : install start
cmsrel  CMSSW_9_3_2

# This is your working directory
# cmsenv : env setting 
cd  CMSSW_9_3_2/src
cmsenv


echo $CMSSW_BASE






