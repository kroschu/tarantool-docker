FROM alpine:3.1

RUN    apk add --update libstdc++ readline libgomp binutils-libs \
    && apk add --update  --virtual .tarantool-deps \
            git cmake g++ make readline-dev perl postgresql-dev \
    && git clone https://github.com/tarantool/tarantool.git /tarantool \
    && git clone https://github.com/tarantool/pg.git /tarantool-pq \
    && cd /tarantool && git submodule update --init --recursive \
    && cmake -DCMAKE_BUILD_TYPE=Release . && make && make install \
    && cd /tarantool-pq && git submodule update --init --recursive \
    && cmake -DCMAKE_BUILD_TYPE=Release . && make && make install \
    && apk del .tarantool-deps \
    && rm /var/cache/apk/* \
    && rm -rf /tarantool*


EXPOSE 3301

COPY ["./run.sh", "/run.sh"]

ENTRYPOINT ["/run.sh"]
