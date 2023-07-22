# place this file in /etc/profile.d/
temp="/opt/jdk/jdk-20.0.2"
if [[ -d $temp ]]; then
  export JDK_HOME=$temp
  export JAVA_HOME=$JDK_HOME
  export CLASSPATH=.:$JAVA_HOME/lib/*
  export PATH=$PATH:$JAVA_HOME/bin
fi
