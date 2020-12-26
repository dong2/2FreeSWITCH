#!/bin/sh
##
##  p12.sh - Collect the user certs and pack into pkcs12 format
##  Copyright (c) 2000 Yeak Nai Siew, All Rights Reserved. 
##

CERT=$1
if [ $# -ne 1 ]; then
        echo "Usage: $0 user@email.address.com"
        exit 1
fi

# Check for requirement
if [ ! -f $CERT.key -o ! -f $CERT.crt -o ! -f ca.crt ]; then
	echo ""
        echo "Cannot proceed because:"
	echo "1. Must have root CA certification"
	echo "2. Must have $CERT.key"
	echo "1. Must have $CERT.crt"
	echo ""
	exit 1
fi

username="`openssl x509 -noout  -in $CERT.crt -subject | sed -e 's;.*CN=;;' -e 's;/Em.*;;'`"
caname="`openssl x509 -noout  -in ca.crt -subject | sed -e 's;.*CN=;;' -e 's;/Em.*;;'`"

# Package it.
openssl pkcs12 \
	-export \
	-in "$CERT.crt" \
	-inkey "$CERT.key" \
	-certfile ca.crt \
	-name "$username" \
	-caname "$caname" \
	-out $CERT.p12

echo ""
echo "The certificate for $CERT has been collected into a pkcs12 file."
echo "You can download to your browser and import it."
echo ""
