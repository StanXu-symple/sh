#!/bin/bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
app_conf="${project_root}/apps/auto-x.conf"

bash -n "$app_conf"
grep -F 'github.com/StanXu-symple/auto-x.git' "$app_conf" >/dev/null
grep -F 'git clone --depth=1 --branch stanxu' "$app_conf" >/dev/null
grep -F 'git -C "$auto_x_install_dir" pull --ff-only "$auto_x_repo_url" stanxu' "$app_conf" >/dev/null
grep -F 'rsync -a --delete' "$app_conf" >/dev/null
grep -F -- "--exclude '.env'" "$app_conf" >/dev/null
grep -F 'auto_x_compose up -d --build --wait' "$app_conf" >/dev/null
grep -F 'auto_x_compose up -d --build --remove-orphans --wait' "$app_conf" >/dev/null
grep -F 'auto_x_compose down --volumes --rmi local --remove-orphans' "$app_conf" >/dev/null
grep -F './data/mysql:/var/lib/mysql' "$app_conf" >/dev/null
grep -F './data/redis:/data' "$app_conf" >/dev/null

echo "auto_x_app_smoke=pass"
