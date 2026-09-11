#!/bin/bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${1:-${project_root}/kejilion.sh}"

choice_function=$(
	awk '
		/^apply_runtime_environment_choice\(\) \{/ { capture=1 }
		capture { print }
		capture && /^}/ { exit }
	' "$script_path"
)
[ -n "$choice_function" ]
eval "$choice_function"

canshu="CN"
apply_runtime_environment_choice ""
[ "$canshu" = "default" ]

apply_runtime_environment_choice 1
[ "$canshu" = "CN" ]

apply_runtime_environment_choice 2
[ "$canshu" = "V6" ]

apply_runtime_environment_choice 3
[ "$canshu" = "default" ]

apply_runtime_environment_choice invalid >/dev/null
[ "$canshu" = "default" ]

select_line="$(grep -n '^select_runtime_environment$' "$script_path" | head -n 1 | cut -d: -f1)"
apply_line="$(grep -n '^quanju_canshu$' "$script_path" | head -n 1 | cut -d: -f1)"
[ -n "$select_line" ]
[ -n "$apply_line" ]
[ "$select_line" -lt "$apply_line" ]
grep -F '1. CN      GitHub 走 gh.kejilion.pro，并启用国内镜像优化' "$script_path" >/dev/null
grep -F '2. V6      GitHub 走 gh.kejilion.pro，不启用 CN 专属优化' "$script_path" >/dev/null
grep -F '3. default GitHub 直连，不启用 CN 专属优化（直接回车）' "$script_path" >/dev/null

echo "runtime_environment_selection_smoke=pass"
