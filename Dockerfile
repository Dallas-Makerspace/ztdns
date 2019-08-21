# Build
FROM golang:latest as BUILDER
ARG CGO_ENABLED
ENV CGO_ENABLED=${CGO_ENABLED:-0}
ARG GOARCH
ENV GOARCH=${GOARCH:-amd64}
ARG GOOS
ENV GOOS=${GOOS:-linux}
WORKDIR /app
RUN go get -u github.com/uxbh/ztdns/ && \
    go build -a -installsuffix cgo -o /app/ztdns github.com/uxbh/ztdns/

# Distribute
FROM scratch
EXPOSE 53/udp
ADD /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from:BUILDER /app/ztdns /ztdns

ENTRYPOINT ["/ztdns"]
CMD ["--debug", "server"]
