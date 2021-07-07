#!/bin/bash

while getopts ":a:m:t:r:u:p:s:" opt; do
  case ${opt} in
    a ) 
        VAULT_ADDR=${OPTARG}
      ;;
    m ) 
        VAULT_METHOD=${OPTARG}
      ;;
    t ) 
        VAULT_TOKEN=${OPTARG}
      ;;
    r ) 
        VAULT_ROLE=${OPTARG}
      ;;
    u ) 
        VAULT_USERNAME=${OPTARG}
      ;;
    p ) 
        VAULT_PASSWORD=${OPTARG}
      ;;
    s ) 
        VAULT_SECRETS=${OPTARG}
      ;;
  esac
done

shift $((OPTIND-1))

echo $VAULT_ADDR
echo $VAULT_METHOD

if [ "$VAULT_METHOD" == "token" ]
then
    echo "Using token method for Vault"
    vault login -address=$VAULT_ADDR -no-print -method=token token=$VAULT_TOKEN
fi

IFS=';' 
read -ra SECRETS <<< "$VAULT_SECRETS"
for i in "${SECRETS[@]}"
do
    IFS='|' read -ra SECRET <<< "$i"
    SECRET_PATH=`echo ${SECRET[0]} | awk '{print $1}'`
    SECRET_FIELD=`echo ${SECRET[0]} | awk '{print $2}'`
    SECRET_NAME=`echo ${SECRET[1]} | xargs`
    SECRET_VALUE=`vault read -address=$VAULT_ADDR -field=$SECRET_FIELD $SECRET_PATH`
    # cleanup secret value for github
    SECRET_VALUE="${SECRET_VALUE//'%'/'%25'}"
    SECRET_VALUE="${SECRET_VALUE//$'\n'/'%0A'}"
    SECRET_VALUE="${SECRET_VALUE//$'\r'/'%0D'}"
    echo "::set-output name=$SECRET_NAME::$SECRET_VALUE"
done
