# The version of Alpine to use for the final image
# This should match the version of Alpine that the `elixir:1.10-alpine` image uses
ARG ALPINE_VERSION=3.11

FROM elixir:1.10-alpine AS builder

# The following are build arguments used to change variable parts of the image.
# The name of your application/release (required)
ARG APP_NAME

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

# Cache the dependency fetching
COPY mix.exs mix.exs

# Cache the dependency fetching
COPY mix.lock mix.lock 

RUN mix do deps.get

RUN MIX_ENV=test mix deps.compile

COPY lib lib

COPY test test

RUN mix test

RUN MIX_ENV=prod mix deps.compile

RUN MIX_ENV=prod mix compile

ARG APP_VSN

ENV APP_VSN=${APP_VSN} \
    MIX_ENV=prod

COPY rel rel

RUN \
  mkdir -p /opt/built && \
  mix release && \
  cp _build/${MIX_ENV}/*.tar.gz /opt/built/built.tar.gz && \
  cd /opt/built && \
  tar -xzf *.tar.gz && \
  rm *.tar.gz

# From this line onwards, we're in a new image, which will be the image used in production
FROM alpine:${ALPINE_VERSION}

# The name of your application/release (required)

RUN apk update && \
    apk add --no-cache \
    bash \
    openssl-dev

WORKDIR /opt/app

COPY --from=builder /opt/built .

EXPOSE 8080

CMD /opt/app/bin/pod_viewer start
