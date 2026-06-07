#
# java
#

setjavahome() {
  emulate -L zsh
  local java_home
  java_home="$(/usr/libexec/java_home 2>/dev/null)" || return 0
  export JAVA_HOME="$java_home"
  export PATH="$JAVA_HOME/bin:$PATH"
}

#setjavahome
