FROM alpine
COPY ./rsyncBrute.sh ./rsyncBrute.sh
COPY ./rockyou.txt /usr/share/wordlists/rockyou.txt
RUN chmod +x ./rsyncBrute.sh
RUN mv rsyncBrute.sh /bin/
RUN apk update && apk add rsync
ENTRYPOINT ["rsyncBrute.sh"]
CMD ["-h"]
