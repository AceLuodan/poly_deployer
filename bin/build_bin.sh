#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="---------------------BUILDING: "

# commits 最开始
# export POLY_CMT=8083385#c9933af59c22f64042cc4850181045096
#Update fabric_handler.go (#71) 31 Jul 2021 https://github.com/polynetwork/poly/commit/0e51ab10951ae2c95b69eeebe6962892b7e67f63
export POLY_CMT=da2c5521739e4099c3b9868be91e6545f6a1f80e
# export ONT_RELAYER=04a071ce01f98678fe1e9b75e3ac73b43301fba6
export ETH_RELAYER=84d43bdd64f60f7278a02a85454941b9aef10674
# export BTC_RELAYER=c0f8dde8d4cb6c18becd6070382113d36fa56794
# export BTC_VENDOR=3b19a5fd76664a7d7c811956f582effcf937810f
# export GAIA_DEMO=d7bdccddca7b01efeabeaa5a7adbacfe75732001
# export COSMOS_RELAYER=2287164b4bd99a175dd6e7a90c848173d850ea38
#无fabric 原始的
export TEST_CMT=8cf514b0775052939ea0e69bf19e90f135ecb612
#无chainID
#https://github.com/polynetwork/poly-io-test/commit/803fc65d4faefb45ae7f2339ca989a6e20c43dfd


# install tools 
if [ ! -x "$(command -v expect)" ]
then
    echo 'Install expect for you...' >&2
    os_name=`uname`
    if [ $os_name = 'Darwin' ]
    then
        if [ ! -x "$(command -v brew)" ]
        then
            echo "no brew is installed, please install brew first. "
            exit 1
        fi
        brew install expect >> /dev/null
        if [ $? -ne 0 ]
        then
            echo "failed to install expect"
            exit 1
        fi
    elif [ $os_name = 'Linux' ]
    then
        if [ -x "$(command -v apt-get)" ]
        then
            apt-get install -y expect >> /dev/null
            if [ $? -ne 0 ]
            then
                echo "failed to install expect"
                exit 1
            fi
        elif [ -x "$(command -v yum)" ]
        then
            yum install -y expect >> /dev/null
            if [ $? -ne 0 ]
            then
                echo "failed to install expect"
                exit 1
            fi
        else
            echo "no yum or apt-get, install expect yourself please. "
            exit 1
        fi
    else
        echo "os not support"
        exit 1
    fi
fi

# make dirs
mkdir -p ${POLY_HOME}/.code/polynetwork
mkdir -p ${POLY_HOME}/.code/ontio
mkdir -p ${POLY_HOME}/.code/zouxyan

# bitcoind


# ethereum
# cd ${POLY_HOME}/.code/
# if [ ! -d ./go-ethereum ]
# then
#     git clone https://github.com/ethereum/go-ethereum.git
# fi
# cd go-ethereum
# #git checkout v1.9.18
# git checkout v1.10.1
# make
# if [ $? -ne 0 ]
# then
#     echo "${LOG_PREFIX}failed to build ethereum"
#     exit 1
# fi
# mv build/bin/geth ${POLY_HOME}/lib/geth/
# echo "${LOG_PREFIX}ethereum built"

# ontology


# poly
cd ${POLY_HOME}/.code/ontio/
if [ ! -d ./poly ]
then
    # git clone https://github.com/polynetwork/poly.git
    git clone https://github.com/AceLuodan/poly
fi
cd poly
# git reset --hard $POLY_CMT
git checkout -b  enterprise  origin/enterprise
make
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build poly"
    exit 1
fi
mv poly ${POLY_HOME}/lib/poly/
echo "${LOG_PREFIX}poly built"

# gaia-demo


# prepare local code resource for go.mod
cd ${POLY_HOME}/.code/polynetwork/
# if [ ! -d ./btc-vendor-tools ]
# then
#     git clone https://github.com/polynetwork/btc-vendor-tools.git
# fi
if [ ! -d ./poly-go-sdk ]
then
    git clone https://github.com/polynetwork/poly-go-sdk.git
fi
git checkout -b  enterprise  origin/enterprise

# btctool


# relayer btc


# relayer eth
cd ${POLY_HOME}/.code/polynetwork
if [ ! -d ./eth-relayer ]
then
    git clone https://github.com/AceLuodan/eth-relayer
    # git clone https://github.com/polynetwork/eth-relayer/
fi
cd eth-relayer
# git reset --hard $ETH_RELAYER
# git checkout -b  test1  origin/test
go mod tidy
go build -o run_eth_relayer main.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build eth relayer"
    exit 1
fi
mv run_eth_relayer ${POLY_HOME}/lib/relayer_eth/
echo "${LOG_PREFIX}eth relayer built"

# relayer ont
# cd ${POLY_HOME}/.code/polynetwork
# if [ ! -d ./ont-relayer ]
# then
#     git clone https://github.com/polynetwork/ont-relayer.git
# fi
# cd ont-relayer
# git reset --hard $ONT_RELAYER
# go build -o run_ont_relayer main.go
# if [ $? -ne 0 ]
# then
#     echo "${LOG_PREFIX}failed to build ont relayer"
#     exit 1
# fi
# mv run_ont_relayer ${POLY_HOME}/lib/relayer_ont/
# echo "${LOG_PREFIX}ont relayer built"

# relayer gaia


# btc vendors


# tools: 
cd ${POLY_HOME}/.code/polynetwork
if [ ! -d ./poly-io-test ]
then
    # git clone https://github.com/polynetwork/poly-io-test
    git clone https://github.com/AceLuodan/poly-io-test.git
fi
cd poly-io-test
git checkout -b  enterprise  origin/enterprise
# git reset --hard 803fc65d4faefb45ae7f2339ca989a6e20c43dfd
go mod tidy
go build -o eth_deployer cmd/eth_deployer/run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build eth_deployer"
    exit 1
fi
# go build -o cosmos_prepare cmd/cosmos_prepare/run.go
# if [ $? -ne 0 ]
# then
#     echo "${LOG_PREFIX}failed to build cosmos_prepare"
#     exit 1
# fi
go build -o side_chain_mgr cmd/tools/run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build side_chain_mgr"
    exit 1
fi
go build -o cctest cmd/cctest/main.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build cctest"
    exit 1
fi

# mv btc_prepare ${POLY_HOME}/lib/tools/contracts_deployer
# mv ont_deployer ${POLY_HOME}/lib/tools/contracts_deployer
mv eth_deployer ${POLY_HOME}/lib/tools/contracts_deployer
# mv cosmos_prepare ${POLY_HOME}/lib/tools/contracts_deployer
mv side_chain_mgr ${POLY_HOME}/lib/tools/side_chain_mgr
mv cctest ${POLY_HOME}/lib/tools/test_tool

echo "=============================================="
echo "all built"
echo "=============================================="
