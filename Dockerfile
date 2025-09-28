FROM openjdk:8-jdk-slim

# Set versions
ENV SCALA_VERSION 2.13.0
ENV SBT_VERSION 1.9.7

# Install prerequisites
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Install SBT
RUN curl -L "https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz" | tar -xz -C /usr/share && \
    ln -s /usr/share/sbt/bin/sbt /usr/local/bin/sbt

# Create app directory
WORKDIR /app

# Create minimal build to preload Scala 3
RUN mkdir -p project && \
    echo "sbt.version=$SBT_VERSION" > project/build.properties && \
    echo 'ThisBuild / scalaVersion := "2.13.0"' > build.sbt && \
    echo 'ThisBuild / name := "scala3-app"' >> build.sbt

# Preload dependencies (makes first run faster)
RUN sbt -Dsbt.rootdir=true -Dsbt.ci=true compile

# Default command
CMD ["sbt"]