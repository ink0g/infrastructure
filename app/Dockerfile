FROM golang:1.26.5-alpine AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 go build -o myapp main.go

FROM alpine:latest AS runer

COPY --from=builder /app/myapp /myapp

CMD ["/myapp"]
