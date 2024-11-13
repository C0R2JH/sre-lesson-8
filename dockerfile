FROM golang:alpine
WORKDIR /otus-app
COPY /otus-app/go.mod ./
RUN go mod download
COPY /otus-app/*.go ./
ENV PORT=80
ENV APP_USER=user
ENV APP_PASSWORD=spassword
RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-otus-sre-lesson-8
CMD ["/docker-otus-sre-lesson-8"]