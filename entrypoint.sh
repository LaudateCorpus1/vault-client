#!/bin/bash

source /bishy.bash

get_longOpt $@

echo "::set-output name=vault_addr_out::$addr"
echo "version 0.16"
echo "---------"
echo $secrets
