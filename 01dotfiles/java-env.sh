# place this file in /etc/profile.d/
export JDK_HOME=/usr/local/java/jdk-11.0.2
export JAVA_HOME=$JDK_HOME
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
