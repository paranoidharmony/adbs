#!/usr/bin/env bash
# 远程安装入口：不依赖当前目录，不覆盖现有目录或命令。
set -euo pipefail
main() {
  local url=https://github.com/paranoidharmony/adbs.git dest=$HOME/.liut/adbs
  mkdir -p -- "$HOME/.liut"
  if [[ -e $dest || -L $dest ]]; then
    if [[ -L $dest || ! -d $dest/.git || $(git -C "$dest" config --local --get remote.origin.url) != "$url" ]]; then
      printf '安装路径已被占用，未修改：%s\n' "$dest" >&2
      return 1
    fi
  else
    git clone --branch main -- "$url" "$dest"
  fi
  "$dest/install.sh"
}
main "$@"
