#!/bin/bash

source /bishy.bash

get_longOpt $@

echo "::set-output name=vault_addr_out::$addr"
echo "version 0.15"
echo "---------"
echo $1
echo "---------"
echo $2
echo "---------"
echo $3
