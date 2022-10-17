#!/bin/bash

#goerli bsctestnet avalanchetestnet fantomtestnet moonbase polygontestnet
testnetChainIds=(5 97 43113 4002 1287 80001)
#Ethereum
mainnetChainIds=(1)

testnetServiceUrl="https://indexer.auditablezk.mystiko.network"
mainnetServiceUrl="https://indexer.mystiko.network"

function check_chain_commitments() {
    serviceUrl=$1
    chainId=$2

    url="${serviceUrl}/chains/${chainId}/commitments?where=%20%20%20%20%7B%0A%20%20%20%20%22status%22%3A%20%7B%22neq%22%3A%22succeeded%22%7D%0A%20%20%20%20%7D"
    commitments=$(curl --silent -X 'GET' $url -H 'accept: application/json')

    code=$(echo $commitments | jq .code)
    result=$(echo $commitments | jq .result)
    if [ "${code}" != "0" ]; then
      echo "failed code ${code}"
      exit 1
    fi

    if [ "${result}" != "[]" ]; then
      echo "failed result ${result}"
      exit 1
    fi
}

# shellcheck disable=SC2068
for id in "${testnetChainIds[@]}"
do
  echo "chain ${id}"
  check_chain_commitments $testnetServiceUrl $id
done

# shellcheck disable=SC2068
for id in "${mainnetChainIds[@]}"
do
  echo "chain ${id}"
  check_chain_commitments $mainnetServiceUrl $id
done
