FROM alpine:3.9
LABEL maintainer "Kevin Collins <kcollins@purelinux.net>"

RUN apk add --no-cache xvfb

ENTRYPOINT [ "Xvfb" ]
CMD [ ":8", "-screen", "0", "1920x1200x16" ]
