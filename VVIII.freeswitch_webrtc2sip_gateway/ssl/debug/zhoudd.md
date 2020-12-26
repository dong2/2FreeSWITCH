# openssl genrsa -des3 -out ca.key 4096
ca.key

# openssl req -new -x509 -days 3650 -config $CONFIG -key ca.key -out ca.crt
ca.crt

# openssl genrsa -out server.key 4096
server.key

# openssl req -new -config $CONFIG -key server.key -out server.csr
server.csr

# openssl ca -config ca.config -out server.crt -infiles server.csr
server.crt

# openssl verify -CAfile ca.crt server.crt

# openssl pkcs12 -export -in server.crt -inkey server.key -out server.pfx
server.pfx

# openssl pkcs12 -in server.pfx -nocerts -nodes -out server.key
server.key

# openssl rsa -in server.key -pubout -out server_pub.key
server_pub.key

# openssl rsa -in  server.key -out server_pri.key
server_pri.key

# openssl pkcs8 -topk8 -inform PEM -in server_pri.key -outform PEM -nocrypt
server_pri.key



