FROM ubuntu                                                                                     

RUN apt-get update

# For add-apt-repositor in order to install Java
RUN apt-get install -y software-properties-common
#RUN apt-get install -y --fix-missing software-properties-common python-software-properties
#RUN apt-get update
#RUN add-apt-repository ppa:webupd8team/java
#RUN apt-get update

# Agree oracle license true
#RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections

# Install Java
#RUN apt-get -y install oracle-java8-installer
#RUN apt-get -y install oracle-java8-set-default

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# No interactive
ENV DEBIAN_FRONTEND noninteractive

# Install and update Android SDK
# 64-bit distributions must be capable of running 32-bit applications. So, need to install lib32stdc++6
ADD expect-android-update.sh .
RUN chmod +x expect-android-update.sh
RUN apt-get install -y wget
RUN apt-get update
RUN apt-get -y install expect
RUN apt-get -y install lib32stdc++6 
RUN wget http://dl.google.com/android/android-sdk_r24.2-linux.tgz && \
    mv android-sdk_r24.2-linux.tgz /opt && \
    cd /opt && \
    tar zxvf android-sdk_r24.2-linux.tgz && \
    rm android-sdk_r24.2-linux.tgz && \
    cd android-sdk-linux && \
    cp -a tools copy-tools && \
    /expect-android-update.sh platform-tools && \
    ls -l && \
    ls -l platform-tools/ && \
    ./platform-tools/adb kill-server && \
    rm -rf temp/ && \
    /expect-android-update.sh tools && \
    /expect-android-update.sh build-tools-22.0.1,android-18,android-19,android-21,android-22,sys-img-armeabi-v7a-android-22,sys-img-armeabi-v7a-android-21,sys-img-armeabi-v7a-android-19,sys-img-armeabi-v7a-android-18
         
ENV ANDROID_SDK_HOME /opt/android-sdk-linux
ENV PATH $PATH:/opt/android-sdk-linux/platform-tools:/opt/android-sdk-linux/tools
RUN echo no | /opt/android-sdk-linux/tools/android create avd -n uiautomator19 -t android-19
