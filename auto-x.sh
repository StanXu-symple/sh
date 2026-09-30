#!/usr/bin/env bash
# Thin entrypoint: reuse the application catalog and its install/update hooks.
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
case "${1:-menu}" in
    install|update|uninstall) export KJ_APP_ACTION="$1" KJ_APP_NONINTERACTIVE=1 ;;
    menu) ;;
    *) echo "用法: bash auto-x.sh [menu|install|update|uninstall] [服务列表]" >&2; exit 2 ;;
esac
if [ -n "${2:-}" ]; then export AUTO_X_SERVICES="$2"; fi
exec bash "$script_dir/kejilion.sh" app auto-x
