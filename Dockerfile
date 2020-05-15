# Build stage
FROM golang@sha256:44e6cf174c26c3c377124e08997c74a3eaba905bc8d78d1cb82ca4626e4b8e24 AS builder
COPY ./pkg timescale-prometheus-connector/pkg
COPY ./cmd timescale-prometheus-connector/cmd
COPY ./go.mod timescale-prometheus-connector/go.mod
COPY ./go.sum timescale-prometheus-connector/go.sum
RUN apk update && apk add --no-cache git \
    && cd timescale-prometheus-connector \
    && go mod download \
    && GOARM=7 GOARCH=arm CGO_ENABLED=0 go build -a --ldflags '-w' -o /go/timescale-prometheus ./cmd/timescale-prometheus

# Final image
FROM busybox@sha256:54afd83d8d86b2fe22678bfff7286ed6c7bf3b60328300fb680641bf105fe9cd
COPY --from=builder /go/timescale-prometheus /
ENTRYPOINT ["/timescale-prometheus"]
