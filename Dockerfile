FROM registry.fedoraproject.org/fedora:31
ENV PYTHONPATH=/opt/koji:/opt/koji/cli
EXPOSE 8080

RUN : \
 && dnf -y --refresh update \
 && dnf -y install \
      httpd \
      python3-mod_wsgi \
      python3-six \
      python3-requests \
      python3-psycopg2 \
      python3-cheetah \
      python3-pyOpenSSL \
      python3-multilib \
      mock \
      nosync \
      git-core \
 && dnf -y clean all \
 && useradd koji \
 && usermod -G mock koji \
 && :

COPY ./ /opt/koji/

RUN : \
 && chown -R apache:apache /opt/koji/ \
 && mkdir /etc/mock/koji/ \
 && chown koji:mock /etc/mock/koji/ \
 && ln -sf ../koji/site-defaults.cfg /etc/mock/site-defaults.cfg \
 && :

USER apache
