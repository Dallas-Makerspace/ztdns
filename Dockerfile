# Build
FROM golang:latest as BUILDER
WORKDIR /app
RUN go get -u github.com/uxbh/ztdns/ && \
    mkdir -p dist && \
    CGO_ENABLED="0" GOARCH="amd64" GOOS="linux" go build -a -installsuffix cgo -o ./dist/ztdns

# Distribute
FROM scratch
EXPOSE 53/udp
ADD /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from:BUILDER /app/dist/ztdns /ztdns

ENTRYPOINT ["/ztdns"]
CMD ["--debug", "server"]
