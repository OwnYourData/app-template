FROM oydeu/r-base_armhf:latest

RUN apt-get update \ 
	&& apt-get install -t unstable -y --no-install-recommends \
                sudo \
                gdebi-core \
                pandoc \
                pandoc-citeproc \
                libcurl4-gnutls-dev \
                libcairo2-dev/unstable \
                libxt-dev \
                cmake \
	&& rm -rf /var/lib/apt/lists/*

ADD shiny-server /home/pi/shiny-server

RUN cd /home/pi/shiny-server/tmp \
        && make install \
        && rm -rf /home/pi

RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')"

RUN ln -s /usr/local/shiny-server/bin/shiny-server /usr/bin/shiny-server \
        && useradd -r -m shiny \
        && mkdir -p /var/log/shiny-server \
        && mkdir -p /srv/shiny-server \
        && mkdir -p /var/lib/shiny-server \
        && mkdir -p /etc/shiny-server \
        && chown shiny /var/log/shiny-server \
        && cd /etc/shiny-server/ \
        && wget http://withr.me/misc/shiny-server.conf

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
