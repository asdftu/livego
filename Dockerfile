FROM golang:latest as builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o livego ./

FROM alpine:latest
LABEL maintainer="gwuhaolin <gwuhaolin@gmail.com>"
ENV RTMP_PORT 19035
ENV HTTP_FLV_PORT 19080
ENV HLS_PORT 7002
ENV HTTP_OPERATION_PORT 8090
COPY --from=builder /app/livego .
EXPOSE ${RTMP_PORT}
EXPOSE ${HTTP_FLV_PORT}
EXPOSE ${HLS_PORT}
EXPOSE ${HTTP_OPERATION_PORT}
CMD ./livego