# nccd cw3


## Testing
There is a test script built into each of the machines found at `/root/test.sh`<br>
The test will attempt to connect to each listening port on every machine in the enviroment<br>
The test script will return a string of numbers corresponing to wether a connection could be made<br>
The `testMachines.sh` script will run these scripts automatically on each machine and then parse the results.
### Results
The test results are displayed as a 0/1 in the following order:
- Ext-WWW
- Ext-DNS
- Int-WWW
- Mail
- LDAP
- Int-DNS
- Squid
- Database (Web)
- Database (Mail)
- Database (HR)
- Staff-HR
- Staff-CC
- Staff-SA
- Staff-FI



## Fun Facts
- [X] 3 databases. two for mail and web servers and one for hr information (Zoneing)
- [X] VPN Server can acess all of Staff Network except System Admin for remoting into own machines
- [X] LDAP can only be accessed by Staff Machines (not VPN clients)
- [X] IDMZ can't talk to other machines on IDMZ (except to DNS)
- [X] Databases can only be accessed by SA and the respected service
- [X] Squid Proxy can only be accessed by Staff Machines
- [X] Theres a printer *woah*
- [X] Functional OpenVPN Server. Ext-Office has a client config that is automatically run
- [X] Squid Proxy is set to be used by default on all Staff Machines
- [X] Test scripts on all the machines with a master script to run them all
- [X] 4 Public IP Addresses. 1 for each service and 1 public facing ip for traffic to other machines
- [X] Subnets for each department
