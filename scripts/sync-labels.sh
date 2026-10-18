#!/usr/bin/env bash
# Requires gh (authenticated with repo scope) and yq
set -euo pipefail

org="sudo-terraform-modules"
labels_file="$(dirname "$0")/../labels.yml"
prune=false
[[ "${1:-}" == "--prune" ]] && prune=true

wanted=$(yq -r '.[].name' "$labels_file")
count=$(yq 'length' "$labels_file")

for repo in $(gh repo list "$org" --no-archived --limit 200 --json name -q '.[].name'); do
  echo "== $repo"
  for ((i = 0; i < count; i++)); do
    name=$(yq -r ".[$i].name" "$labels_file")
    gh label create "$name" -R "$org/$repo" --force \
      --color "$(yq -r ".[$i].color" "$labels_file")" \
      --description "$(yq -r ".[$i].description" "$labels_file")" >/dev/null
  done
  if $prune; then
    while read -r existing; do
      grep -qxF "$existing" <<<"$wanted" || gh label delete "$existing" -R "$org/$repo" --yes
    done < <(gh label list -R "$org/$repo" --limit 200 --json name -q '.[].name')
  fi
done
