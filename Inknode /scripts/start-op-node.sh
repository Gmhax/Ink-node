#!/bin/sh
set -e

# Wait for the Bedrock flag for this network to be set.
echo "Waiting for Bedrock node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
  sleep 1
done

export EXTENDED_ARG="${EXTENDED_ARG:-} --network=$NETWORK_NAME --rollup.load-protocol-versions=true --rollup.halt=major"

# Override Holocene
if [ ! -z "$OVERRIDE_HOLOCENE" ]; then
  EXTENDED_ARG="$EXTENDED_ARG --override.holocene=$OVERRIDE_HOLOCENE"
fi

# Start op-node.
exec op-node \
  --l1=$OP_NODE__RPC_ENDPOINT \
  --l2=http://op-geth:8551 \
  --rpc.addr=0.0.0.0 \
  --rpc.port=9545 \
  --l2.jwt-secret=/shared/jwt.txt \
  --l1.trustrpc \
  --l1.rpckind=$OP_NODE__RPC_TYPE \
  --l1.beacon=$OP_NODE__L1_BEACON \
  --metrics.enabled \
  --metrics.addr=0.0.0.0 \
  --metrics.port=7300 \
  --syncmode=consensus-layer \
  --p2p.scoring=none \
  --p2p.listen.ip=0.0.0.0 \
  --p2p.listen.tcp=9222 \
  --p2p.listen.udp=9222 \
  $EXTENDED_ARG $@
