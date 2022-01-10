#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="REGISTER AND SYNC_GENESIS_HDR: "
BORDER="----------------------------------------------"

echo "${BORDER} start to register side chain and sync genesis header ${BORDER}"

echo "${LOG_PREFIX}start to register side chain"
${POLY_HOME}/lib/tools/side_chain_mgr -tool register_side_chain  -chainid 7  -conf ${POLY_HOME}/lib/tools/config.json -pwallets "${POLY_HOME}/lib/poly/wallet1.dat,${POLY_HOME}/lib/poly/wallet2.dat,${POLY_HOME}/lib/poly/wallet3.dat" -ppwds "4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc"
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to register_side_chain"
    exit 1
fi

# echo "${LOG_PREFIX}start to sync genesis header side chain"
# ${POLY_HOME}/lib/tools/side_chain_mgr -tool sync_genesis_header -chainid 7 -conf ${POLY_HOME}/lib/tools/config.json -pwallets "${POLY_HOME}/lib/poly/wallet.dat,${POLY_HOME}/lib/poly/wallet1.dat,${POLY_HOME}/lib/poly/wallet2.dat,${POLY_HOME}/lib/poly/wallet3.dat" -ppwds "4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc" 
# if [ $? -ne 0 ]
# then
#     echo "${LOG_PREFIX}failed to sync genesis header"
#     exit 1
# fi

echo "${LOG_PREFIX}start to SyncFabricRootCA to poly chain"
${POLY_HOME}/lib/tools/side_chain_mgr -tool sync_fabric_root_ca -rootca "/root/fabric-relayer/root-cert.pem"  -chainid 7  -conf ${POLY_HOME}/lib/tools/config.json -pwallets "${POLY_HOME}/lib/poly/wallet.dat,${POLY_HOME}/lib/poly/wallet1.dat,${POLY_HOME}/lib/poly/wallet2.dat,${POLY_HOME}/lib/poly/wallet3.dat" -ppwds "4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc"
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to SyncFabricRootCA"
    exit 1
fi

echo "${LOG_PREFIX}start to  fabric relayer"
#${POLY_HOME}/lib/tools/side_chain_mgr -tool sync_fabric_root_ca -rootca "/Users/danluo/Desktop/ld/github/new/fabric-relayer/root-cert.pem"  -chainid 7  -conf ${POLY_HOME}/lib/tools/config.json -pwallets "${POLY_HOME}/lib/poly/wallet.dat,${POLY_HOME}/lib/poly/wallet1.dat,${POLY_HOME}/lib/poly/wallet2.dat,${POLY_HOME}/lib/poly/wallet3.dat" -ppwds "4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc"
/root/fabric-relayer/cmd/cmd  --loglevel 1  > /root/fabric-relayer/mylog.log 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to fabric relayer"
    exit 1
fi


echo "${BORDER} done ${BORDER}"
echo
