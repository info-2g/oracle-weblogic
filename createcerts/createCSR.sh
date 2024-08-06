MYCERT=server1
openssl req -new -out $MYCERT.csr -newkey rsa:2048 -keyout $MYCERT.key -nodes -config $MYCERT.v3.ext
#openssl req -new -out $MYCERT.csr -key $MYCERT.key -nodes -config $MYCERT.v3.ext
