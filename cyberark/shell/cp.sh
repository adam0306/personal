#!/bin/bash

#Create Help information.
display_help() {
    echo "Usage: $0 [option...] {start|stop|restart}" >&2
    echo "   -r, --resolution           run with the given resolution WxH"
    echo "   -d, --display              Set on which display to host on "
    # echo some stuff here for the -a or --add-options 
    exit 1
}

# Converting provided input to $app variable.
$app = $1
# Converting provided input to $safe variable.
$safe = $2
# Converting provided input to $obj variable.
$obj = $3

# Execute with path
#$result = "./opt/CARKaim/sdk/clipasswordsdk GetPassword -p AppDescs.AppID=<$app> -p Query="Safe=<$safe>;Object=<$obj>" -p RequiredProps=Address,UserName -o Password,PassProps.UserName"

# Execute with path
cd /opt/CARKaim/sdk/
$result = "./clipasswordsdk GetPassword -p AppDescs.AppID=<$app> -p Query="Safe=<$safe>;Object=<$obj>" -p RequiredProps=Address,UserName -o Password,PassProps.UserName"

# Print username and password to terminal.
echo $result.UserName
echo $result.Password
