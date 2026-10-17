#!/bin/bash
L=$HOME/dlog.txt
: > $L
exec >>$L 2>&1
echo "=== START7"
export PATH=/opt/cpanel/ea-nodejs22/bin:$PATH
cd $HOME/rel3
node -e 'console.log("node ok")' 2>&1 | head -2
echo "-- plain build"; node node_modules/vite/bin/vite.js build 2>&1 | tail -3
echo "-- wasm trap handler off"; NODE_OPTIONS=--disable-wasm-trap-handler node node_modules/vite/bin/vite.js build 2>&1 | tail -3
echo "-- heap 1g + trap off via npm"; NODE_OPTIONS="--disable-wasm-trap-handler --max-old-space-size=1024" npm run build 2>&1 | tail -4
echo "-- npm_config_update_notifier"; npm_config_update_notifier=false NODE_OPTIONS=--disable-wasm-trap-handler npm run build 2>&1 | tail -4
echo "=== END7"
