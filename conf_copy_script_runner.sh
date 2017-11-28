#!/bin/bash 
echo "copies config variables from one cloud-functions environment to another"
echo "--------------------------------"
echo "checking arguments"
if [ $1 == "" || $2 == "" || $3 == "" || $4 == ""]; then
  echo "cannot find variable"
  exit 1
fi

cd $4
echo "entering to $4 folder"
firebase use $1
configfile=$1'_to_'$2-$(date "+%b_%d_%Y_%H_%M_%S")
firebase functions:config:get > $configfile'.json'
echo "$configfile from $1 has been loaded"

ALIAS_1=$1
if [ $1 == 'dev' ]; then
  ALIAS_1='a23d2'
fi

ALIAS_2=$2
if [ $2 == 'dev' ]; then
  ALIAS_2='a23d2'
fi

echo "preparing configfile for environment $2"
python3 $3'convert_nest_dict.py' -f $4$configfile
echo "replacing $ALIAS_1 for $ALIAS_2"
python3 $3'mod_param.py' -ST $ALIAS_1 -RT $ALIAS_2 -F $4$configfile
echo "$configfile for $2 has been created"

#cd /home/ubuntu/dev/projects/smashcut/cloud-functions/

firebase use $2

chmod 755 $configfile'.sh'
echo "updating $2"
./$configfile'.sh'