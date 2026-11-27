# 只接管裸 su；带参数的调用保留 KernelSU 原有语义和返回值。
su() {
  if (( $# )); then
    command su "$@"
  else
    command su -c 'exec /system/bin/sh /data/local/tmp/adbs/usr/libexec/start-zsh --keep-cwd'
  fi
}

# KernelSU 的 -c 接受命令字符串；逐个参数用单引号编码，再以空格连接。
sudo() {
  emulate -L zsh
  if (( $# == 0 )); then
    print -u2 '用法：sudo 命令 [参数...]'
    return 2
  fi
  if (( EUID == 0 )); then
    command -- "$@"
  else
    command su -c "exec /system/bin/sh /data/local/tmp/adbs/usr/libexec/start-zsh --exec ${(j: :)${(qq)@}}"
  fi
}
