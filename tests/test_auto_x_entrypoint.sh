#!/usr/bin/env bash
set -euo pipefail
root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
workspace="$(mktemp -d)"
trap 'rm -rf "$workspace"' EXIT
cp "$root_dir/auto-x.sh" "$workspace/auto-x.sh"
cat > "$workspace/kejilion.sh" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "${KJ_APP_ACTION:-}" "${KJ_APP_NONINTERACTIVE:-}" "${AUTO_X_SERVICES:-}" "$*"
STUB
result="$(bash "$workspace/auto-x.sh" update xhs-worker,camoufox-worker)"
expected="$(printf '%s\n' update 1 xhs-worker,camoufox-worker 'app auto-x')"
test "$result" = "$expected"
if bash "$workspace/auto-x.sh" unknown >/dev/null 2>&1; then exit 1; fi
echo 'auto_x_entrypoint=pass'
