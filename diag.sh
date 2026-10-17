#!/bin/bash
L=$HOME/dlog.txt
: > $L
exec >>$L 2>&1
echo "=== START5"
(cd ~/public_html && php -v | head -1)
P=/opt/cpanel/ea-php83/root/usr/bin/php
echo "--- composer 8.3 default memory"
rm -rf $HOME/rel3; mkdir -p $HOME/rel3; cp -R . $HOME/rel3; cd $HOME/rel3
$P /usr/local/bin/composer install --no-dev --optimize-autoloader --no-interaction 2>&1 | egrep -i "error|memory|Generating|fail" | head
echo "composer exit=${PIPESTATUS[0]}"
cp $HOME/shared.env .env
$P artisan key:generate 2>&1 | tail -1
$P artisan migrate --force 2>&1 | tail -6
$P artisan optimize 2>&1 | tail -3
$P artisan schedule:run 2>&1 | tail -2
$P artisan queue:restart 2>&1 | tail -1
echo "--- PATH-prefix trick"
mkdir -p $HOME/bin83; ln -sfn $P $HOME/bin83/php; PATH=$HOME/bin83:$PATH composer --version 2>&1 | head -2
echo "--- npm install"
export PATH=/opt/cpanel/ea-nodejs22/bin:$PATH
echo '{"name":"t","private":true,"devDependencies":{"vite":"^5.0.0"},"scripts":{"build":"vite build"}}' > package.json
S=$(date +%s); npm install --no-audit --no-fund 2>&1 | tail -3; echo "npm secs=$(( $(date +%s)-S ))"
npx vite --version
echo "=== END5"
