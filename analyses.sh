#!/bin/bash
# Run an analysis

HELP="usage: $0 [EVM_BYTECODE]
  submit EVM bytecode for analysis. Either pass the bytecode as a parameter
or set environment variable EVM_BYTECODE.
"

cd $(dirname ${BASH_SOURCE[0]})

# Set up API KEY
. ./common.sh

(( $# == 1 )) && EVM_BYTECODE=$1

if [[ -z $EVM_BYTECODE ]] ; then
    echo >&2 "You need to either pass EVM bytecode as a string or set variable EVM_BYTECODE"
    exit 1
fi

# Run the command for the analysis
prefix="POST ${MYTHRIL_API_URL}/v1/analyses"
echo "Issuing HTTP $prefix
  (with MYTHRIL_API_KEY and EVM bytecode)
"
curl -i -X $prefix \
  -H "Authorization: Bearer $MYTHRIL_API_KEY" \
  -H 'Content-Type: application/json' \
  -d "{
    \"type\": \"bytecode\",
    \"contract\": \"$EVM_BYTECODE\"
}" >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
