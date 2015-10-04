FROM ubuntu:14.04

MAINTAINER "Giovanni Colapinto" alfheim@syshell.net

RUN rm -rf /var/lib/apt/lists/ \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    supervisor \
    sudo \
	python-pip \
	python-dev \
	build-essential \
	git \
	libxml2-dev \
	libxslt1-dev \
	zlib1g-dev \
	libffi-dev \
	libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

RUN pip install scrapyd

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/log/supervisor \
  && chgrp staff /var/log/supervisor \
  && chmod g+w /var/log/supervisor \
  && chgrp staff /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /etc/scrapyd/ /var/lib/scrapyd/{eggs,dbs,logs,items}

COPY scrapyd.conf /etc/scrapyd/scrapyd.conf

EXPOSE 6800

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
