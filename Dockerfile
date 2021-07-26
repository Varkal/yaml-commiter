FROM mikefarah/yq

USER root
RUN apk add git
USER yq
WORKDIR /workdir

COPY yaml-commit.sh /usr/local/bin/yaml-commit

ENTRYPOINT [ "yaml-commit" ]
