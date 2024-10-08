#################
# Builder Image #
#################

FROM golang:1.21.5-alpine as builder

ENV GO111MODULE=on
WORKDIR /app
# Download all dependencies
COPY go.mod .
RUN go mod download
# Copy in the code and compile
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o /go/bin/hello

#################
#################
# Release Image #
#################
#################

FROM alpine:3.12
RUN apk add --no-cache ca-certificates

ENV USER=hello
ENV GROUP=hello

# Add new user to run as
RUN addgroup -S -g 111 $GROUP && adduser -S -G $GROUP $USER
ENV APP_HOME=/home/$USER
WORKDIR $APP_HOME

# Copy in binary and give permissions
COPY --from=builder /go/bin/hello $APP_HOME
RUN chmod +x $APP_HOME/hello
RUN chown -R $USER:$GROUP $APP_HOME

USER $USER

ENTRYPOINT [ "./hello" ]
