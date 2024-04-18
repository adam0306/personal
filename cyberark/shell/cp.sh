#!/bin/bash

# Set Path to directory of SDK.
#export PATH=$PATH:/opt/CARKaim/sdk
# Store user input in variables.
# app = $1
# username = $2
# safe = $3

$app = $1
$safe = $2
$obj = $3

#cd /opt/CARKaim/sdk/

$result = "./opt/CARKaim/sdk/clipasswordsdk GetPassword -p AppDescs.AppID=<$app> -p Query="Safe=<$safe>;Object=<$obj>" -p RequiredProps=Address,UserName -o Password,PassProps.UserName"

# Print username and password to terminal.
echo $result.UserName
echo $result.Password
