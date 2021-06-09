turnserver -o -a -f -v --mobility -m 10 --max-bps=1024000 --min-port=16384 --max-port=32768 --user=test:test123 -r test
# turnserver.conf

#listening-device  #-d
#listening-ip      #-L
#listening-port    #-p
#relay-device      #-i
#relay-ip          #-E
#external-ip       #-X
verbose            #-v                 
fingerprint        #-f                 
#no-auth           #-z
lt-cred-mech       #-a
relay-threads=10   #-m
min-port=16384     #--min-port         
max-port=32768     #--max-port         
user=test:test123  #-u                  
realm=test         #-r                 


listening-port=3478
verbose
fingerprint
lt-cred-mech
mobility
relay-threads=10
min-port=16384
max-port=32768
user=test:test123
realm=test


turnserver -o -c /etc/turnserver.conf
