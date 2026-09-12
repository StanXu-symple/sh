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
grep -F 'auto_x_normalize_services()' "$app_conf" >/dev/null
grep -F 'auto_x_add_service_dependencies()' "$app_conf" >/dev/null
grep -F 'docker_app_prepare_install()' "$app_conf" >/dev/null
grep -F 'auto_x_select_services false' "$app_conf" >/dev/null
grep -F 'docker_app_install_requires_port()' "$app_conf" >/dev/null
grep -F 'auto_x_service_selected backend' "$app_conf" >/dev/null
grep -F '[ "${app_id:-}" = "auto-x" ] || return 0' "$app_conf" >/dev/null
grep -F 'monitor-agent 是每台 Docker 主机的必装服务' "$app_conf" >/dev/null
grep -F 'monitor-agent（必装，自动加入）' "$app_conf" >/dev/null
grep -F 'auto_x_add_required_service monitor-agent' "$app_conf" >/dev/null
grep -F 'auto_x_add_required_service auth-center' "$app_conf" >/dev/null
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
grep -F 'auto_x_check_nacos' "$app_conf" >/dev/null
grep -F -- '--check' "$app_conf" >/dev/null
grep -F '正在验证 Nacos 地址、账号和密码' "$app_conf" >/dev/null
grep -F 'Nacos 连接或认证验证失败，请从地址开始重新填写' "$app_conf" >/dev/null
grep -F 'Nacos 验证程序不支持 --check' "$app_conf" >/dev/null
grep -F 'auto_x_set_env_if_default NACOS_CONFIG_REQUIRED "true" "false"' "$app_conf" >/dev/null
grep -F 'auto_x_set_env_if_default BACKEND_HOST_PORT "8200" "8000"' "$app_conf" >/dev/null
grep -F 'auto_x_set_env_if_default WORKER_HOST_PORT "8201" "8001"' "$app_conf" >/dev/null
grep -F 'auto_x_set_env_if_default AI_WORKER_HOST_PORT "8202" "8002"' "$app_conf" >/dev/null
grep -F 'auto_x_set_env_if_default QQ_WORKER_HOST_PORT "8203" "8003"' "$app_conf" >/dev/null
grep -F 'auto_x_set_env SERVICE_AUTH_KEY_ENCRYPTION_KEY' "$app_conf" >/dev/null
grep -F 'auto_x_set_env ENVIRONMENT "production"' "$app_conf" >/dev/null
grep -F 'auto_x_report_data_topology' "$app_conf" >/dev/null
grep -F 'docker-compose.external.yml' "$app_conf" >/dev/null
grep -F 'NACOS_CONFIG_DATA_ID' "$app_conf" >/dev/null
grep -F 'XHS_WORKER_IMAGE' "$app_conf" >/dev/null

service_hook_body="$({
    awk '
        /^auto_x_normalize_services\(\) \{/ { capture=1 }
        /^auto_x_service_selected\(\) \{/ { capture=1 }
        /^auto_x_add_required_service\(\) \{/ { capture=1 }
        /^auto_x_add_service_dependencies\(\) \{/ { capture=1 }
        /^docker_app_install_requires_port\(\) \{/ { capture=1 }
        capture { print }
        capture && /^}$/ { print ""; capture=0 }
    ' "$app_conf"
})"
eval "$service_hook_body"
test "$(auto_x_normalize_services 'backend,, frontend,backend')" = "backend,frontend"
test "$(auto_x_normalize_services ' all ')" = "backend,frontend,worker,ai-worker,qq-worker,xhs-worker,auth-center,monitor-center,monitor-agent"
if auto_x_normalize_services 'backend,unknown-service' >/dev/null 2>&1; then
    echo "unknown Auto-X service was accepted" >&2
    exit 1
fi
AUTO_X_SERVICES="backend,frontend"
auto_x_add_service_dependencies
test "$AUTO_X_SERVICES" = "backend,frontend,auth-center,monitor-agent"
AUTO_X_SERVICES="worker"
auto_x_add_service_dependencies
test "$AUTO_X_SERVICES" = "worker,monitor-agent"
AUTO_X_SERVICES="monitor-center,auth-center,monitor-agent"
auto_x_add_service_dependencies
test "$AUTO_X_SERVICES" = "monitor-center,auth-center,monitor-agent"
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

external_data_body="$(
    awk '
        /^auto_x_uses_external_data\(\) \{/ { capture=1 }
        capture { print }
        capture && /^}$/ { exit }
    ' "$app_conf"
)"
eval "$external_data_body"
topology_dir="$(mktemp -d)"
auto_x_install_dir="$topology_dir"
auto_x_get_env() {
    local line
    line="$(grep -m1 -E "^${1}=" "$2" 2>/dev/null || true)"
    printf '%s' "${line#*=}"
}
printf '%s\n' 'POSTGRES_HOST=postgres' 'REDIS_HOST=redis' > "$topology_dir/.env"
if auto_x_uses_external_data; then
    echo "local PostgreSQL/Redis were misclassified as external" >&2
    exit 1
else
    test "$?" -eq 1
fi
printf '%s\n' 'POSTGRES_HOST=10.0.0.10' 'REDIS_HOST=10.0.0.11' > "$topology_dir/.env"
auto_x_uses_external_data
printf '%s\n' 'POSTGRES_DSN=postgresql+asyncpg://db/x' 'REDIS_URL=redis://cache/0' > "$topology_dir/.env"
auto_x_uses_external_data
printf '%s\n' 'POSTGRES_HOST=10.0.0.10' 'REDIS_HOST=redis' > "$topology_dir/.env"
if auto_x_uses_external_data 2>/dev/null; then
    echo "partial external data configuration was accepted" >&2
    exit 1
else
    test "$?" -eq 2
fi
rm -rf "$topology_dir"

configure_body="$(
    awk '
        /^auto_x_configure_nacos\(\) \{/ { capture=1 }
        capture { print }
        capture && /^}$/ { exit }
    ' "$app_conf"
)"
eval "$configure_body"
nacos_addr_value=""
nacos_namespace_value=""
nacos_user_value=""
nacos_password_value=""
auto_x_get_env() {
    case "$1" in
        NACOS_SERVER_ADDR) printf '%s' "$nacos_addr_value" ;;
        NACOS_NAMESPACE) printf '%s' "$nacos_namespace_value" ;;
        NACOS_USERNAME) printf '%s' "$nacos_user_value" ;;
        NACOS_PASSWORD) printf '%s' "$nacos_password_value" ;;
    esac
}
auto_x_set_env() {
    case "$1" in
        NACOS_SERVER_ADDR) nacos_addr_value="$2" ;;
        NACOS_NAMESPACE) nacos_namespace_value="$2" ;;
        NACOS_USERNAME) nacos_user_value="$2" ;;
        NACOS_PASSWORD) nacos_password_value="$2" ;;
    esac
}
nacos_check_attempts=0
auto_x_check_nacos() {
    nacos_check_attempts=$((nacos_check_attempts + 1))
    [ "$nacos_check_attempts" -eq 2 ]
}
nacos_env_file="$(mktemp)"
auto_x_configure_nacos "$nacos_env_file" <<'EOF' >/dev/null
http://bad-nacos:8848
public
nacos
bad-password
http://good-nacos:8848


good-password
EOF
rm -f "$nacos_env_file"
test "$nacos_check_attempts" -eq 2
test "$nacos_addr_value" = "http://good-nacos:8848"
test "$nacos_password_value" = "good-password"

echo "auto_x_app_smoke=pass"
