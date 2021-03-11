# docker build ./docker-images/ssh -t modicn/phabricator:ssh && docker push modicn/phabricator:ssh

FROM modicn/phabricator:base

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        openssh-server \
    ; \
    rm -rf /var/cache/apk/*

COPY ./rootfs /

ENTRYPOINT ["entrypoint-sshd.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e"]
