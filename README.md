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
- [ ] 3 databases. two for mail and web servers and one for hr information (Zoneing)
- [ ] VPN Server can acess all of Staff Network except System Admin for remoting into own machines
- [ ] LDAP can only be accessed by Staff Machines (not VPN clients)
- [ ] IDMZ can't talk to other machines on IDMZ (except to DNS)
- [ ] Databases can only be accessed by SA and the respected service
- [ ] Squid Proxy can only be accessed by Staff Machines
- [ ] Theres a printer *woah*
- [ ] Functional OpenVPN Server. Ext-Office has a client config that is automatically run
- [ ] Squid Proxy is set to be used by default on all Staff Machines
- [ ] Test scripts on all the machines with a master script to run them all
- [ ] 4 Public IP Addresses. 1 for each service and 1 public facing ip for traffic to other machines
- [ ] Subnets for each department
