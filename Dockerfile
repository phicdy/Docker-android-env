FROM ubuntu                                                                                     

RUN apt-get update

# For add-apt-repositor in order to install Java
RUN apt-get install -y software-properties-common
# Install Java
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
RUN wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    mv android-sdk_r24.4.1-linux.tgz /usr/local && \
    cd /usr/local && \
    tar zxvf android-sdk_r24.4.1-linux.tgz && \
    rm android-sdk_r24.4.1-linux.tgz && \
    cd android-sdk-linux && \
    cp -a tools copy-tools && \
    /expect-android-update.sh platform-tools && \
    ./platform-tools/adb kill-server && \
    rm -rf temp/ && \
    /expect-android-update.sh tools && \
    /expect-android-update.sh build-tools-23.0.3,android-23,android-18,sys-img-armeabi-v7a-android-23,extra-android-m2repository,extra-google-m2repository,extra-android-support
         
ENV ANDROID_SDK_HOME /usr/local/android-sdk-linux
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:/usr/local/android-sdk-linux/platform-tools:/usr/local/android-sdk-linux/tools
RUN mkdir /shared
RUN apt-get -y install python
RUN apt-get -y install vim
