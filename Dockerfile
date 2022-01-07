FROM golang

RUN mkdir /certs

WORKDIR /code

COPY . /code

RUN cp /code/webhook-key.pem /certs && \
    cp /code/webhook.crt /certs

RUN go build ./...

ENTRYPOINT ["/code/k8s-controller-pr"]