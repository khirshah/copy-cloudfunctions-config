#!/bin/bash 
clear
echo "Copies functions:config from one cloud-functions environment to another"
echo "--------------------------------"
echo
echo "...Checking arguments"
echo

if [ -z "$1" ] || [ -z "$2" ]; then 
  echo 'Cannot find arguments for Firebase ENVs'
  echo 'Usage:'
  echo '  conf_copy_script_runner.sh source target [firebase_project_folder] [source_alias] [target_alias]'
  exit 1
fi

SOURCE_ENV=$1
TARGET_ENV=$2

if [ $3 == "" ]; then
  SOURCE_DIR="."
else
  SOURCE_DIR=$3
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $SOURCE_DIR
echo "...Entering $SOURCE_DIR folder"
firebase use $SOURCE_ENV
CONFIG_FILE=$SOURCE_ENV'_to_'$TARGET_ENV-$(date "+%b_%d_%Y_%H_%M_%S")
firebase functions:config:get > $CONFIG_FILE'.json'
echo "...$CONFIG_FILE from $1 has been loaded"

ALIAS_1=$SOURCE_ENV
if [ $4 != "" ]; then
  ALIAS_1=$4
fi

ALIAS_2=$TARGET_ENV
if [ $5 != "" ]; then
  ALIAS_2=$5
fi

echo "...Preparing configfile for environment $TARGET_ENV"
python3 $DIR'convert_nest_dict.py' -f $SOURCE_DIR$CONFIG_FILE

echo "...Saving backup config scrip"
cp $SOURCE_DIR$CONFIG_FILE rollback-$SOURCE_DIR$CONFIG_FILE

echo "...Replacing $ALIAS_1 for $ALIAS_2"
python3 $DIR'mod_param.py' -ST $ALIAS_1 -RT $ALIAS_2 -F $SOURCE_DIR$CONFIG_FILE
echo "...Configfile for $TARGET_ENV has been created"

firebase use $TARGET_ENV

chmod 755 $CONFIG_FILE'.sh'
echo "...Updating $TARGET_ENV"
./$CONFIG_FILE'.sh'
