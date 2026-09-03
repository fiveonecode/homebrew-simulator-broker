#!/usr/bin/env bash
# Shared Autopilot and GitHub Actions gate for this tap.
set -euo pipefail

export HOMEBREW_NO_ANALYTICS="${HOMEBREW_NO_ANALYTICS:-1}"
export HOMEBREW_NO_AUTO_UPDATE="${HOMEBREW_NO_AUTO_UPDATE:-1}"
export HOMEBREW_NO_COLOR="${HOMEBREW_NO_COLOR:-1}"
export HOMEBREW_NO_REQUIRE_TAP_TRUST="${HOMEBREW_NO_REQUIRE_TAP_TRUST:-1}"
unset GITHUB_ACTIONS
unset GITHUB_WORKFLOW

repo_root="$(cd "$(dirname "${0}")/.." && pwd)"
overlay_dir="$(brew --repository)/Library/Taps/fiveonecodeci/homebrew-simulator-broker"
mkdir -p "$(dirname "${overlay_dir}")"
ln -sfn "${repo_root}" "${overlay_dir}"
brew trust --tap fiveonecodeci/simulator-broker >/dev/null 2>&1 || true

brew style fiveonecodeci/simulator-broker
brew audit --strict --skip-style --formula fiveonecodeci/simulator-broker/simbroker
brew audit --strict --skip-style --cask fiveonecodeci/simulator-broker/simulator-broker
brew audit --strict --online --skip-style --formula fiveonecodeci/simulator-broker/simbroker

cask_online_output="$(
  set +e
  brew audit --strict --online --skip-style --cask fiveonecodeci/simulator-broker/simulator-broker 2>&1
  printf '<<exit:%s>>\n' "${?}"
)"
cask_online_status="${cask_online_output##*<<exit:}"
cask_online_status="${cask_online_status%%>>*}"
cask_online_body="${cask_online_output%<<exit:*}"
printf '%s' "${cask_online_body}"

if [[ "${cask_online_status}" == "0" ]]
then
  exit 0
fi

unexpected=0
while IFS= read -r line
do
  [[ -z "${line// /}" ]] && continue
  stripped="$(printf '%s' "${line}" | sed $'s/\033\\[[0-9;]*[A-Za-z]//g')"
  if [[ ! "${stripped}" =~ ^[[:space:]]+[-*][[:space:]] ]]
  then
    continue
  fi
  case "${stripped}" in
    *"is a GitHub pre-release."* | *"differs from '' retrieved by livecheck."*)
      continue
      ;;
    *)
      printf 'Unexpected cask --online audit finding: %s\n' "${stripped}" >&2
      unexpected=1
      ;;
  esac
done <<<"${cask_online_body}"

if [[ "${unexpected}" -ne 0 ]]
then
  exit 1
fi
