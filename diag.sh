#!/bin/bash
L=$HOME/dlog.txt
: > $L
exec >>$L 2>&1
echo "=== START4"
php -v | head -1; php -r 'echo "mem=",ini_get("memory_limit"),"\n";'
composer --version 2>&1 | head -2
echo "--- composer via wrapper php, default memory"
rm -rf $HOME/rel2; mkdir -p $HOME/rel2; cp -R . $HOME/rel2; cd $HOME/rel2
php /usr/local/bin/composer install --no-dev --optimize-autoloader --no-interaction 2>&1 | egrep -i "error|memory|Generating|exit|fail" | head
echo "composer exit=${PIPESTATUS[0]}"
/usr/bin/env php -v | head -1
cp .env.example .env
cp $HOME/shared.env .env
php artisan key:generate 2>&1 | tail -1
php artisan migrate --force 2>&1 | tail -6
php artisan optimize 2>&1 | tail -3
php artisan schedule:run 2>&1 | tail -2
echo "--- node on PATH?"; command -v node || echo none
export PATH=/opt/cpanel/ea-nodejs22/bin:$PATH; node -v; npm -v
echo "--- npm install vite"
S=$(date +%s); npm ci --no-audit --no-fund 2>&1 | tail -3; echo "npm secs=$(( $(date +%s)-S ))"
npm run build 2>&1 | tail -5
echo "=== END4"
