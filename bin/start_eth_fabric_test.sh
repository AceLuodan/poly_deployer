#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX='start-fabric '
BORDER="----------------------------------------------"

echo "${BORDER} start fabric cross test  ${BORDER}"


${POLY_HOME}/lib/tools/test_tool --cfg /root/poly/poly_deployer/lib/tools/config.json --t EthToFabric
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX} failed to start fabric cross test"
    exit 1
else
    echo "${LOG_PREFIX} successful to start fabric cross test "
fi

echo "${BORDER} start fabric cross test ${BORDER}"
echo
