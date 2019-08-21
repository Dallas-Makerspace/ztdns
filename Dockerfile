FROM scratch

EXPOSE 53/udp
ADD /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ADD ./dist/zeroteir /ztdns

ENTRYPOINT ["/ztdns"]
CMD ["--debug", "server"]
