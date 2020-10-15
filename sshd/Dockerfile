FROM modicn/phabricator:eval

COPY ./copy /

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e"]

USER vcs
