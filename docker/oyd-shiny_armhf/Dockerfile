FROM oydeu/shiny_armhf:latest

RUN apt-get -y update \
        && apt-get install -y --no-install-recommends \
                git \
                wget \
                libcurl4-openssl-dev \
                libssl-dev \
                libxml2-dev \
                libssh2-1-dev \
                libmariadb-client-lgpl-dev \
                libpq-dev \ 
		libcairo2 \
		libcairo2-dev \
        && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
        && locale-gen en_US.utf8 \
        && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN wget https://raw.githubusercontent.com/OwnYourData/app-bank/master/init.r && \
    R -e "source('init.r')" && \
    rm -f init.r

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
