# copy-cloudfunctions-config
Is a small script that copies config settings between *firebase-cloudfunctions* environments

## Pre-requisite
Python 3.x

## Install 
```

git@github.com:khirshah/copy-cloudfunctions-config.git

```     

## Run
```

path-to-copy-cloudfunctions-config/conf_copy_script_runner.sh source target [firebase_project_folder] [source_alias] [target_alias]

```

### Arguments
```
$1 source environment
$2 target environment
$3 location of firebase project folder
$4 source alias
$5 target alias
```

eg.: conf_copy_script_runner.sh source target [firebase_project_folder] [source_alias] [target_alias]
