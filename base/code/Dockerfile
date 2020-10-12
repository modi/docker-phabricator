# docker build . -t modicn/phabricator:code && docker push modicn/phabricator:code

FROM alpine:3.12 AS download

RUN set -ex; \
    mkdir /code /tmp/download; \
    wget -q https://github.com/phacility/phabricator/archive/5e06d924f8eba5df354c690ceb693e454e965d16.zip -O /tmp/download/phabricator.zip; \
    unzip -d /code -q /tmp/download/phabricator.zip; \
    mv /code/phabricator-5e06d924f8eba5df354c690ceb693e454e965d16 /code/phabricator; \
    wget -q https://github.com/phacility/arcanist/archive/68dba1a2c6d9fe1de7b9d4c944336458d0f016b3.zip -O /tmp/download/arcanist.zip; \
    unzip -d /code -q /tmp/download/arcanist.zip; \
    mv /code/arcanist-68dba1a2c6d9fe1de7b9d4c944336458d0f016b3 /code/arcanist; \
    ln -s /code/arcanist/bin/arc /usr/local/bin/arc; \
    wget -q https://github.com/PHPOffice/PHPExcel/archive/1.8.2.zip -O /tmp/download/phpexcel.zip; \
    unzip -d /code -q /tmp/download/phpexcel.zip; \
    wget -q "https://github.com/arielyang/phabricator_zh_Hans/raw/master/dist/(stable)%20Promote%202020%20Week%2037/PhabricatorSimplifiedChineseTranslation.php" -O /code/phabricator/src/extensions/PhabricatorSimplifiedChineseTranslation.php; \
    rm -rf /tmp/download

FROM scratch

COPY --from=download /code/ /code/

