# 只验证本地运行，不发网络请求，不抓包。
() {
  emulate -L zsh
  (( $+functions[zimfw] && $+functions[compdef] )) && [[ -n ${key_info[Up]} ]] || return 1
  local fn
  for fn in _zsh_autosuggest_start _zsh_highlight_highlighter_main_paint history-substring-search-up prompt-pwd _prompt_asciiship_vimode; do
    (( $+functions[$fn] )) || { print -u2 "Zim 模块未就绪：$fn"; return 1; }
  done
  [[ ${_comps[age]:-} == _age ]] || { print -u2 '扩展补全未注册'; return 1; }
  local user=shell
  (( EUID == 0 )) && user=root
  [[ $HOME == $ADBS_ROOT/home/$user && $HISTFILE == $HOME/.local/state/zsh_history &&
     -s $ZIM_HOME/init.zsh && -s $HOME/.cache/zcompdump && -d $TMPDIR ]] || {
    print -u2 'HOME 或会话状态路径异常'; return 1
  }
  local tool
  for tool in zsh busybox tree curl tcpdump dig; do
    [[ ${commands[$tool]:-} == $ADBS_ROOT/usr/bin/$tool ]] || { print -u2 "缺少内置命令：$tool"; return 1; }
  done
  [[ -s $CURL_CA_BUNDLE ]] || { print -u2 '找不到 curl CA 证书包'; return 1; }
  zsh --version && busybox true && tree --version && curl --version && tcpdump --version && dig -v
}
