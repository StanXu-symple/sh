#!/bin/bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
app_conf="${project_root}/apps/auto-x.conf"

bash -n "$app_conf"
grep -F 'github.com/StanXu-symple/auto-x.git' "$app_conf" >/dev/null
grep -F 'git clone --depth=1 --branch main' "$app_conf" >/dev/null
grep -F 'git -C "$auto_x_install_dir" pull --ff-only "$auto_x_repo_url" main' "$app_conf" >/dev/null
grep -F 'rsync -a --delete' "$app_conf" >/dev/null
grep -F -- "--exclude '.env'" "$app_conf" >/dev/null
grep -F 'auto_x_compose up -d --no-build --wait' "$app_conf" >/dev/null
grep -F 'auto_x_compose up -d --no-build --remove-orphans --wait' "$app_conf" >/dev/null
if grep -F 'docker rm -f x-sentinel-xhs-worker-1' "$app_conf" >/dev/null; then
    echo "auto-x update must not remove the active xhs-worker" >&2
    exit 1
fi
grep -F 'auto_x_compose down --volumes --rmi local --remove-orphans' "$app_conf" >/dev/null
grep -F './data/postgres:/var/lib/postgresql/data' "$app_conf" >/dev/null
grep -F './data/redis:/data' "$app_conf" >/dev/null
grep -F 'auto_x_sync_nacos_config' "$app_conf" >/dev/null
grep -F 'NACOS_CONFIG_DATA_ID' "$app_conf" >/dev/null
grep -F 'XHS_WORKER_IMAGE' "$app_conf" >/dev/null

echo "auto_x_app_smoke=pass"
