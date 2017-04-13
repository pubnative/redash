FROM redash/base:latest

RUN apt-get update && \
  apt-get install -y python-pip python-dev curl build-essential pwgen libffi-dev sudo git-core wget nodejs \
  # Postgres client
  libpq-dev \
  # Additional packages required for data sources:
  libssl-dev libmysqlclient-dev freetds-dev libsasl2-dev && \
  curl https://deb.nodesource.com/setup_4.x | bash - \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# We first copy only the requirements file, to avoid rebuilding on every file
# change.
COPY requirements.txt requirements_dev.txt requirements_all_ds.txt ./
RUN pip install -r requirements.txt -r requirements_dev.txt -r requirements_all_ds.txt

COPY . ./
RUN chown -R redash /app
RUN sudo -u redash -H make deps \
  && rm -rf node_modules rd_ui/node_modules /home/redash/.npm /home/redash/.cache

USER redash

ENTRYPOINT ["/app/bin/docker-entrypoint"]