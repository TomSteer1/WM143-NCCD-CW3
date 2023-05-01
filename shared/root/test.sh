#!/bin/bash
echo "Running test script" 1>&2
result=""

# Test if the machine can reach the external site
echo "Testing external site" 1>&2
curl -s -q http://faceybooky.com --connect-timeout 5 --head | head -n 1 | grep "200 OK" 1>&2
if [ $? -ne 0 ]; then
	echo "Cannot reach external site" 1>&2
	result+="0"
else
	echo "Can reach external site" 1>&2
	result+="1"
fi


# Test if the machine can reach the external dns
echo "Testing external dns" 1>&2
host -t a faceybooky.com 8.8.8.8 -W 2 | grep "has address" 1>&2
if [ $? -ne 0 ]; then
	echo "Cannot reach external dns" 1>&2
	result+="0"
else
	echo "Can reach external dns" 1>&2
	result+="1"
fi

# Test if the machine can reach the internal site
echo "Testing internal site" 1>&2
curl -s -q http://www.fido22.cyber.test --connect-timeout 5 --head | head -n 1 | grep "200 OK" 1>&2
if [ $? -ne 0 ]; then
	echo "Cannot reach internal site" 1>&2
	result+="0"
else
	echo "Can reach internal site" 1>&2
	result+="1"
fi

# Test if the machine can reach the vpn server
#echo "Testing vpn server" 1>&2
#nc -z -w 2 vpn.fido22.cyber.test 1194 

# Test if the machine can reach the mail server
echo "Testing mail server" 1>&2
nc -zv -w 2 mail.fido22.cyber.test 25
port25=$?
nc -zv -w 2 mail.fido22.cyber.test 587
port587=$?
nc -zv -w 2 mail.fido22.cyber.test 993
port993=$?
if [ $port25 -ne 0 ] || [ $port587 -ne 0 ] || [ $port993 -ne 0 ]; then
	echo "Cannot reach mail server" 1>&2
	result+="0"
else
	echo "Can reach mail server" 1>&2
	result+="1"
fi

# Test if the machine can reach the ldap server
echo "Testing ldap server" 1>&2
# TCP 389
nc -zv -w 2 ldap.fido22.cyber.test 389
port389=$?
# UDP 389 echo check
echo "LDAP Test" | nc -u -w 2 ldap.fido22.cyber.test 389 | grep "LDAP Test" 1>&2
port389u=$?
if [ $port389 -ne 0 ] || [ $port389u -ne 0 ]; then
	echo "Cannot reach ldap server" 1>&2
	result+="0"
else
	echo "Can reach ldap server" 1>&2
	result+="1"
fi

# Test if the machine can reach the internal dns
echo "Testing internal dns" 1>&2
host -t a www.fido22.cyber.test 10.4.0.1 | grep "has address" 1>&2
if [ $? -ne 0 ]; then
	echo "Cannot reach internal dns" 1>&2
	result+="0"
else
	echo "Can reach internal dns" 1>&2
	result+="1"
fi

# Test if the machine can reach the squid proxy
echo "Testing squid proxy" 1>&2
curl -s -q http://www.fido22.cyber.test --proxy "http://squid.fido22.cyber.test:3129" --connect-timeout 5 --head 1>&2
if [ $? -ne 0 ]; then
	echo "Cannot reach squid proxy" 1>&2
	result+="0"
else
	echo "Can reach squid proxy" 1>&2
	result+="1"
fi

# Test if the machine can reach the web database
echo "Testing web database" 1>&2
nc -zv -w 2 mysql.fido22.cyber.test 3306
if [ $? -ne 0 ]; then
	echo "Cannot reach web database" 1>&2
	result+="0"
else
	echo "Can reach web database" 1>&2
	result+="1"
fi

# Test if the machine can reach the mail database
echo "Testing mail database" 1>&2
nc -zv -w 2 mysql.fido22.cyber.test 3307
if [ $? -ne 0 ]; then
	echo "Cannot reach mail database" 1>&2
	result+="0"
else
	echo "Can reach mail database" 1>&2
	result+="1"
fi

# Test if the machine can reach the hr database
echo "Testing hr database" 1>&2
nc -zv -w 2 mysql.fido22.cyber.test 3308
if [ $? -ne 0 ]; then
	echo "Cannot reach hr database" 1>&2
	result+="0"
else
	echo "Can reach hr database" 1>&2
	result+="1"
fi

# Test ssh to each staff machine
echo "Testing ssh to staff machines" 1>&2
# HR
nc -zv -w 2 10.2.0.1 22
if [ $? -ne 0 ]; then
	echo "Cannot reach HR machine" 1>&2
	result+="0"
else
	echo "Can reach HR machine" 1>&2
	result+="1"
fi
# CC
nc -zv -w 2 10.2.4.1 22
if [ $? -ne 0 ]; then
	echo "Cannot reach CC machine" 1>&2
	result+="0"
else
	echo "Can reach CC machine" 1>&2
	result+="1"
fi
# SA
nc -zv -w 2 10.2.8.1 22
if [ $? -ne 0 ]; then
	echo "Cannot reach System Admin machine" 1>&2
	result+="0"
else
	echo "Can reach System Admin machine" 1>&2
	result+="1"
fi
# Finance
nc -zv -w 2 10.2.12.1 22
if [ $? -ne 0 ]; then
	echo "Cannot reach finance machine" 1>&2
	result+="0"
else
	echo "Can reach finance machine" 1>&2
	result+="1"
fi


echo "Test script complete" 1>&2
echo $result
echo $result > /hostlab/_test/$(hostname).txt
