#!/bin/bash

while getopts ":a:m:t:r:u:p:s:" opt; do
  case ${opt} in
    a ) 
        VAULT_ADDR=`echo ${OPTARG} | xargs`
      ;;
    m ) 
        VAULT_METHOD=`echo ${OPTARG} | xargs`
      ;;
    t ) 
        VAULT_TOKEN=`echo ${OPTARG} | xargs`
      ;;
    r ) 
        VAULT_ROLE=`echo ${OPTARG} | xargs`
      ;;
    u ) 
        VAULT_USERNAME=`echo ${OPTARG} | xargs`
      ;;
    p ) 
        VAULT_PASSWORD=`echo ${OPTARG} | xargs`
      ;;
    s ) 
        VAULT_SECRETS=${OPTARG}
      ;;
  esac
done

shift $((OPTIND-1))

if [ "$VAULT_METHOD" == "token" ]
then
    echo "Using token method for Vault"
    vault login -address=$VAULT_ADDR -no-print -method=token token=$VAULT_TOKEN
fi

if [ "$VAULT_METHOD" == "aws" ]
then
    echo "Using AWS method for Vault"
    vault login -address=$VAULT_ADDR -no-print -method=aws role=$VAULT_ROLE
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
