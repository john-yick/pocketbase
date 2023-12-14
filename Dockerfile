FROM alpine:latest

ARG PB_VERSION=0.20.0

RUN apk add --no-cache \
    unzip \
    ca-certificates

# local user to run under
RUN addgroup -S pb && adduser -S pb -G pb

# download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /usr/local/bin/pb/
RUN rm /tmp/pb.zip

# create data directory
RUN mkdir /pb_data
RUN mkdir /pb_migrations

# set permissions
RUN chown pb:pb /usr/local/bin/pb
RUN chown pb:pb /pb_data
RUN chown pb:pb /pb_migrations
RUN chmod 710 /usr/local/bin/pb



VOLUME /pb_data
VOLUME /pb_migrations
USER pb
EXPOSE 8080

# start PocketBase
CMD ["/usr/local/bin/pb/pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=/pb_data"]