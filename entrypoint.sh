#!/bin/bash

source /bishy.bash

get_longOpt $@

echo "::set-output name=vault_addr_out::$addr"
echo "version 0.13"
echo $secrets
