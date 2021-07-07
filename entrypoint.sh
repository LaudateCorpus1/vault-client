#!/bin/bash

source /bishy.bash

get_longOpt $@

echo "::set-output name=vault_addr_out::$vault_addr"
echo "Hello from vault-client"
