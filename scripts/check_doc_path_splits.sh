#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

allowed_dirs=(
  "bluebook"
  "bluebook/api"
  "bluebook/architecture"
  "bluebook/casebooks"
  "bluebook/guides"
  "bluebook/navigation"
  "bluebook/philosophy"
  "bluebook/playbooks"
  "bluebook/risk"
  "bluebook/security"
  "bluebook/security/appendix"
  "bluebook/security/source-notes"
  "bluebook/userbook"
  "bluebook/userbook/01-主线使用"
  "bluebook/userbook/02-能力地图"
  "bluebook/userbook/02-能力地图/01-运行时主链"
  "bluebook/userbook/02-能力地图/02-执行与工具"
  "bluebook/userbook/02-能力地图/03-治理与边界"
  "bluebook/userbook/02-能力地图/04-扩展与生态"
  "bluebook/userbook/02-能力地图/05-体验与入口"
  "bluebook/userbook/03-参考索引"
  "bluebook/userbook/03-参考索引/01-命令工具"
  "bluebook/userbook/03-参考索引/02-能力边界"
  "bluebook/userbook/03-参考索引/03-技能与扩展"
  "bluebook/userbook/04-专题深潜"
  "bluebook/userbook/05-控制面深挖"
)

unexpected=()
while IFS= read -r dir; do
  skip=false
  for allowed in "${allowed_dirs[@]}"; do
    if [[ "$dir" == "$allowed" ]]; then
      skip=true
      break
    fi
  done

  if [[ "$skip" == false ]]; then
    unexpected+=("$dir")
  fi
done < <(find bluebook -type d | sort)

if ((${#unexpected[@]} > 0)); then
  echo "Unexpected nested documentation directories detected."
  echo "These usually mean a '/' in a document title was written as a path separator."
  printf '%s\n' "${unexpected[@]}"
  exit 1
fi

echo "No split documentation paths detected."
