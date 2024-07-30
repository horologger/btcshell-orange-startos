#!/bin/bash
#exec /bin/start.sh &
#exec /bin/launch-edgestore.sh &
DAOS=$(uname -s | tr '[:upper:]' '[:lower:]')
# echo $DAOS
if [ "$DAOS" == "linux" ]; then
  echo "Running on Linux"
  FNOS="linux"
else
  echo "Running on Mac"
  FNOS="darwin"
fi

DAARCH=$(uname -p | tr '[:upper:]' '[:lower:]')
# echo $DAARCH
if [ "$DAARCH" == "x86_64" ]; then
  echo "Running on x86_64"
  FNARCH="amd64"
else
  echo "Running on ARM"
  FNARCH="arm64"
fi
# echo $FNOS
# echo $FNARCH

FNVER="v0.18.1-beta"

# This is being done in btcshell instead
#LNDFN="lnd-$FNOS-$FNARCH-$FNVER.tar.gz"
#echo $LNDFN
#
#wget -O /tmp/lnd.tar.gz https://github.com/lightningnetwork/lnd/releases/download/$FNVER/$LNDFN
#tar xzf /tmp/lnd.tar.gz -C /tmp
#cp /tmp/lnd-linux-arm64-v0.17.4-beta.rc1/lncli /usr/local/bin

LNDFN="lnd-$FNOS-$FNARCH-$FNVER.tar.gz"
echo "Getting: "$LNDFN

#wget -O /tmp/lnd.tar.gz https://github.com/lightningnetwork/lnd/releases/download/$FNVER/$LNDFN
#tar xzf /tmp/lnd.tar.gz -C /tmp
#cp /tmp/lnd-$FNOS-$FNARCH-$FNVER/lncli /usr/local/bin

mkdir -p /data/bin
echo 'export PATH=/data/bin:$PATH' >> /root/.bashrc

export LNCLI_RPCSERVER="lnd.embassy:10009"       #the LND gRPC address, eg. localhost:10009 (used with the LND backend)
export LNCLI_TLSCERTPATH="/mnt/lnd/tls.cert"    #the location where LND's tls.cert file can be found (used with the LND backend)
export LNCLI_MACAROONPATH="/mnt/lnd/admin.macaroon" #the location where LND's admin.macaroon file can be found (used with the LND backend)

export TOR_ADDRESS=$(yq e '.tor-address' /data/start9/config.yaml)
export LAN_ADDRESS=$(yq e '.lan-address' /data/start9/config.yaml)
export APP_USER=$(yq e ".user" /data/start9/config.yaml)
export APP_PASSWORD=$(yq e ".password" /data/start9/config.yaml)

echo APP_USER = $APP_USER
echo APP_PASSWORD = $APP_PASSWORD

GOTTY_CREDS=$APP_USER:$APP_PASSWORD

echo GOTTY_CREDS = $GOTTY_CREDS

# This is being done in btcshell instead

#mkdir -p /data/bin
#echo '#!/bin/bash' > /data/setpath
#echo 'export PATH=/data/bin:$PATH' >> /data/setpath
#chmod a+x /data/setpath

exec /usr/bin/gotty --port 8080 -c $GOTTY_CREDS --permit-write --reconnect /bin/bash