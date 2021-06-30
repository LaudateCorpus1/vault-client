#!/bin/bash

source bishy.bash

get_longOpt $@

echo "::set-output name=vault_addr::$vault_addr"
