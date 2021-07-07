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

echo "::set-output name=vault_addr_out::$VAULT_ADDR"
echo "version 0.18"
echo "---------"
echo $VAULT_SECRETS
