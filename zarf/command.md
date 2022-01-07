* download the k8s api package
```
$ go get -u k8s.io/api 
```

* generate pem key for webhook 
```
$ cat csr/csr.json | cfssl genkey - | cfssljson -bare webhook
cat webhook.csr | base64 | tr -d '\n'; echo
echo -n "`crt`" | base64 --decode > sj.crt
```


* generate csr, key with openssl
```
$ cat > openssl.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = k8s-custom-controller.default.svc
DNS.2 = k8s-custom-controller.default.svc.cluster.local
EOF

$ openssl genrsa -out webhook-key.pem 2048
$ openssl req -new -key webhook-key.pem -subj "/CN=system:node:k8s-custom-controller.default.svc.cluster.local/O=system:nodes" -out webhook.csr -config openssl.cnf
```