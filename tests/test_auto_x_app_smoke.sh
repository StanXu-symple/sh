#!/bin/bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
app_conf="${project_root}/apps/auto-x.conf"

bash -n "$app_conf"
grep -F 'github.com/StanXu-symple/auto-x.git' "$app_conf" >/dev/null
grep -F 'KJ_AUTO_X_IMAGE_REGISTRY' "$app_conf" >/dev/null
grep -F 'auto_x_image_registry%/' "$app_conf" >/dev/null
grep -F 'KJ_AUTO_X_IMAGE_REGISTRY:-ghcr.dockerproxy.net' "$app_conf" >/dev/null
grep -F 'auto_x_set_env_if_default' "$app_conf" >/dev/null
grep -F 'gh.kejilion.pro/github.com/StanXu-symple/auto-x.git' "$app_conf" >/dev/null
grep -F 'KJ_AUTO_X_GIT_TIMEOUT_SECONDS' "$app_conf" >/dev/null
grep -F 'auto_x_compose_pull' "$app_conf" >/dev/null
grep -F 'KJ_AUTO_X_PULL_RETRIES' "$app_conf" >/dev/null
grep -F 'auto_x_load_selected_services' "$app_conf" >/dev/null
grep -F 'selected="$(head -n 1 "$auto_x_services_file")"' "$app_conf" >/dev/null
grep -F 'auto_x_service_selected()' "$app_conf" >/dev/null
grep -F 'docker_app_prepare_install()' "$app_conf" >/dev/null
grep -F 'auto_x_select_services false' "$app_conf" >/dev/null
grep -F 'docker_app_install_requires_port()' "$app_conf" >/dev/null
grep -F 'auto_x_service_selected backend' "$app_conf" >/dev/null
grep -F '[ "${app_id:-}" = "auto-x" ] || return 0' "$app_conf" >/dev/null
grep -F 'monitor-agent 是每台 Docker 主机的必装服务' "$app_conf" >/dev/null
grep -F 'monitor-agent（必装，自动加入）' "$app_conf" >/dev/null
grep -F '*,monitor-agent,*)' "$app_conf" >/dev/null
grep -F 'selected="${selected},monitor-agent"' "$app_conf" >/dev/null
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

service_hook_body="$({
    awk '
        /^auto_x_service_selected\(\) \{/ { capture=1 }
        /^docker_app_install_requires_port\(\) \{/ { capture=1 }
        capture { print }
        capture && /^}$/ { print ""; capture=0 }
    ' "$app_conf"
})"
eval "$service_hook_body"
app_id="auto-x"
AUTO_X_SERVICES="monitor-agent"
if docker_app_install_requires_port; then
    echo "monitor-agent-only install must not request the application port" >&2
    exit 1
fi
AUTO_X_SERVICES="backend,monitor-agent"
docker_app_install_requires_port
app_id="another-app"
AUTO_X_SERVICES="monitor-agent"
docker_app_install_requires_port

echo "auto_x_app_smoke=pass"
