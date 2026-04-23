#
# java
#

setjavahome() {
  emulate -L zsh
  export JAVA_HOME="$(/usr/libexec/java_home)"
  export PATH="$JAVA_HOME/bin:$PATH"
}

setjavahome
