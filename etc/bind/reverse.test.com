$TTL 604800
@	IN	SOA	fido22.cyber.test. (
	3
	604800
	86400
	2419200
	604800
)

10.4.0.3	IN 	PTR 	squid
10.4.0.1	IN 	PTR 	dns
10.1.0.2	IN 	PTR	mail
10.1.0.1	IN 	PTR 	www
10.1.0.3	IN 	PTR 	vpn
10.4.0.2	IN 	PTR 	ldap
10.6.0.1	IN 	PTR 	mysq
