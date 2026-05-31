FROM jenkins/jenkins:lts-jdk21

USER root

RUN apt-get update && apt-get install -y \
    apt-utils \
    curl \
    gnupg \
    lsb-release \
    unzip \
    git

# 1. Cài đặt Docker CLI 
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y docker-ce-cli

# 2. Cài đặt SonarScanner CLI 
RUN curl -o sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip && \
    unzip sonar-scanner.zip -d /opt && \
    rm sonar-scanner.zip && \
    mv /opt/sonar-scanner-5.0.1.3006-linux /opt/sonar-scanner

RUN echo "sonar.host.url=http://sonarqube-yas:9000" >> /opt/sonar-scanner/conf/sonar-scanner.properties && \
    echo "sonar.sourceEncoding=UTF-8" >> /opt/sonar-scanner/conf/sonar-scanner.properties

# 3. Cài đặt Snyk CLI 
RUN curl -L https://static.snyk.io/cli/latest/snyk-linux -o /usr/local/bin/snyk && \
    chmod +x /usr/local/bin/snyk

# 4. Cài đặt Gitleaks 
RUN curl -L https://github.com/gitleaks/gitleaks/releases/download/v8.18.2/gitleaks_8.18.2_linux_x64.tar.gz -o gitleaks.tar.gz && \
    tar -xzf gitleaks.tar.gz -C /usr/local/bin gitleaks && \
    rm gitleaks.tar.gz

ENV PATH="$PATH:/opt/sonar-scanner/bin"

USER jenkins