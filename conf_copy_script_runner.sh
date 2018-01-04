#!/bin/bash 
echo "copies config variables from one cloud-functions environment to another"
echo "--------------------------------"
echo "checking arguments"
if [ $1 == "" || $2 == "" || $3 == "" ]; then
  echo "cannot find variable"
  exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $3
echo "entering $3 folder"
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
python3 $DIR'convert_nest_dict.py' -f $3$configfile
echo "saving backup config scrip"
cp $3$configfile rollback-$3$configfile
echo "replacing $ALIAS_1 for $ALIAS_2"
python3 $DIR'mod_param.py' -ST $ALIAS_1 -RT $ALIAS_2 -F $3$configfile
echo "$configfile for $2 has been created"

firebase use $2

chmod 755 $configfile'.sh'
echo "updating $2"
./$configfile'.sh'
