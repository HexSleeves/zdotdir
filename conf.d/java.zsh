#
# java
#

setjavahome() {
  emulate -L zsh
  export JAVA_HOME="$(/usr/libexec/java_home)"
}
