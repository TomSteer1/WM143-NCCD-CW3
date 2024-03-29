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
ldapresult=$(echo "LDAP Test" | nc -u -w 2 ldap.fido22.cyber.test 389 | grep "LDAP Test")
if [ $port389 -ne 0 ] || [[ $ldapresult != "LDAP Test" ]]; then
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
	echo "Cannot reach Corporate Comms machine" 1>&2
	result+="0"
else
	echo "Can reach Corporate Comms machine" 1>&2
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
	echo "Cannot reach Finance machine" 1>&2
	result+="0"
else
	echo "Can reach Finance machine" 1>&2
	result+="1"
fi
# OpenVPN Server
vpnresult=$(nmap -p 1194 -sU -Pn vpn.fido22.cyber.test | grep "openvpn")
if [[ $vpnresult != "1194/udp open  openvpn" ]]; then
	echo "Cannot reach OpenVPN Server" 1>&2
	result+="0"
else
	echo "Can reach OpenVPN Server" 1>&2
	result+="1"
fi
# Staff Printer
udpnmapcount=$(nmap -p 53,137,161,5353 -sU -Pn 10.2.16.1 | grep "open " | wc -l)
tcpnmapcount=$(nmap -p 53,139,443,515,631,9100,9101,9102 -Pn 10.2.16.1 | grep "open " | wc -l)
if [ $udpnmapcount -ne 4 ] || [ $tcpnmapcount -ne 8 ]; then
	echo "Cannot reach Staff Printer" 1>&2
	result+="0"
else
	echo "Can reach Staff Printer" 1>&2
	result+="1"
fi

echo "IMCP Tests" 1>&2
IPs=("8.8.8.8" "22.39.224.18" "201.224.19.7" "10.6.0.1" "10.4.0.1" "10.1.0.1" "10.4.0.2" "10.1.0.2" "10.1.0.3" "10.4.0.3" "10.2.4.1" "10.2.12.1" "10.2.0.1" "10.2.8.1" "10.2.16.1")
for ip in "${IPs[@]}"; do 
	pingresult=$(ping -c 1 -W 0.5 -q $ip | awk '/transmitted/ {print $4}')
	echo $pingresult
	if [ "$pingresult" != "1" ]; then
		echo "Cannot reach $ip" 1>&2
		result+="0"
	else
		echo "Can reach $ip" 1>&2
		result+="1"
	fi
done

echo "Test script complete" 1>&2
echo $result
echo $result > /hostlab/_test/$(hostname).txt
