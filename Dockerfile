FROM ruby:2.2.2

# REDIS-CLI
RUN cd /tmp &&\
    curl -sL http://download.redis.io/redis-stable.tar.gz | tar xz &&\
    make -C redis-stable &&\
    cp -v redis-stable/src/redis-cli /usr/local/bin &&\
    rm -vrf /tmp/redis-stable

# POSTGRES
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.5" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get install -y libpq-dev postgresql-9.5 postgresql-client-9.5 && \
    service postgresql start

# NODE
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

# PhantomJS
RUN apt-get install -y libfontconfig
RUN curl -sL https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -xj
RUN ln -s $(pwd)/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /bin/phantomjs

RUN apt-get install -y libqt4-dev libqtwebkit-dev

ENTRYPOINT service postgresql start && sleep 30s && rspec spec/models/article_spec.rb
