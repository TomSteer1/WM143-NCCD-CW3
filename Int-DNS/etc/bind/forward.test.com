eTTL	604800
@	IN	SOA 	fido22.cyber.test (
	3
	604800
	86400
	2419200
	604800)
;
;@	IN 	NS	localhost
;@	IN 	A 	127.0.0.1
;@ 	IN 	AAAA	::1


; mail
fido22.cyber.test.	IN 	MX	10	mail.fido2.cyber.test.

squid	IN	A	10.1.0.2 
dns 	IN	A	10.4.0.1
mail 	IN	A	10.1.0.2
www	IN	A	10.1.0.1
vpn	IN	A	10.1.0.3
ldap	IN	A	10.4.0.2
mysql	IN	A	10.6.0.1
