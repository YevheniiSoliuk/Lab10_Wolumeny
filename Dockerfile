FROM alpine:latest
RUN apk add --no-cache bash
ADD pluto.sh /
RUN chmod 777 /pluto.sh
VOLUME ["/logi"]
ENTRYPOINT ["bash","pluto.sh"]