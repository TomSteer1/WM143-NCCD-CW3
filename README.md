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



## todo
- [ ] Move Squid from EDMZ to IDMZ in diagrams
