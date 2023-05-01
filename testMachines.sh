#!/bin/bash
echo "Removing previous tests" 1>&2
rm _test/*.txt 2>/dev/null
echo "Starting machines" 1>&2
lstart --tmux-detached
echo "Machines started" 1>&2
echo "Getting list of machines" 1>&2
machines=$(vconnect -l | awk '{print $1}')
for machine in $machines; do
	# Remove colon from machine name
	machine=${machine%:}
	echo "Testing $machine" 1>&2
	# Runs a dump command to ensure the script runs properly
	vcommand $machine "id" &> /dev/null
	vcommand $machine "/root/test.sh" &> /dev/null
done
echo "All machines tested" 1>&2
echo "Waiting for machines to finish" 1>&2
# Wait for number of machines to equal number of files in _test
while [ $(ls _test | wc -l) -ne $(vconnect -l | wc -l) ]; do
	sleep 1
done
echo "Stopping machines" 1>&2
lcrash 1>/dev/null
echo "Machines stopped" 1>&2
#echo "Results are:" 1>&2
#for machine in $machines; do
	# Remove colon from machine name
#	machine=${machine%:}
#	echo "$machine: $(cat _test/$machine.txt)" 1>&2
#done
echo "Parsing results" 1>&2
# Parse Results into arrays of machine names each represented by a bit in the result
ExtWWW=( ) # External Web Server
ExtDNS=( ) # External DNS Server
IntWWW=( ) # Internal Web Server
Mail=( ) # Mail Server
LDAP=( ) # LDAP Server
IntDNS=( ) # Internal DNS Server
Squid=( ) # Squid Proxy
WebDB=( ) # Web Database
MailDB=( ) # Mail Database
HrDB=( ) # HR Database
StaffHR=( ) # Staff HR Machine
StaffCC=( ) # Staff CC Machine
StaffSA=( ) # Staff SA Machine
StaffFI=( ) # Staff FI Machine
for machine in $machines; do
	machine=${machine%:}
	result=$(cat _test/$machine.txt)
	if [ ${result:0:1} -eq 1 ]; then
		ExtWWW+=($machine)
	fi
	if [ ${result:1:1} -eq 1 ]; then
		ExtDNS+=($machine)
	fi
	if [ ${result:2:1} -eq 1 ]; then
		IntWWW+=($machine)
	fi
	if [ ${result:3:1} -eq 1 ]; then
		Mail+=($machine)
	fi
	if [ ${result:4:1} -eq 1 ]; then
		LDAP+=($machine)
	fi
	if [ ${result:5:1} -eq 1 ]; then
		IntDNS+=($machine)
	fi
	if [ ${result:6:1} -eq 1 ]; then
		Squid+=($machine)
	fi
	if [ ${result:7:1} -eq 1 ]; then
		WebDB+=($machine)
	fi
	if [ ${result:8:1} -eq 1 ]; then
		MailDB+=($machine)
	fi
	if [ ${result:9:1} -eq 1 ]; then
		HrDB+=($machine)
	fi
	if [ ${result:10:1} -eq 1 ]; then
		StaffHR+=($machine)
	fi
	if [ ${result:11:1} -eq 1 ]; then
		StaffCC+=($machine)
	fi
	if [ ${result:12:1} -eq 1 ]; then
		StaffSA+=($machine)
	fi
	if [ ${result:13:1} -eq 1 ]; then
		StaffFI+=($machine)
	fi
done
# Prints what machines can be accessed by
# Checks if length of array is equal to number of machines
count=$(ls _test | wc -l)
echo "Test run with $count machines" > _test/results.txt
if [ ${#ExtWWW[@]} -eq $count ]; then
	echo "External Web Server can be accessed by all machines" | tee -a _test/results.txt
else
	echo "External Web Server can be accessed by ${ExtWWW[@]}" | tee -a _test/results.txt
fi
if [ ${#ExtDNS[@]} -eq $count ]; then
	echo "External DNS Server can be accessed by all machines" | tee -a _test/results.txt
else
	echo "External DNS Server can be accessed by ${ExtDNS[@]}" | tee -a _test/results.txt
fi
if [ ${#IntWWW[@]} -eq $count ]; then
	echo "Internal Web Server can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Internal Web Server can be accessed by ${IntWWW[@]}" | tee -a _test/results.txt
fi
if [ ${#Mail[@]} -eq $count ]; then
	echo "Mail Server can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Mail Server can be accessed by ${Mail[@]}" | tee -a _test/results.txt
fi
if [ ${#LDAP[@]} -eq $count ]; then
	echo "LDAP Server can be accessed by all machines" | tee -a _test/results.txt
else
	echo "LDAP Server can be accessed by ${LDAP[@]}" | tee -a _test/results.txt
fi
if [ ${#IntDNS[@]} -eq $count ]; then
	echo "Internal DNS Server can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Internal DNS Server can be accessed by ${IntDNS[@]}" | tee -a _test/results.txt
fi
if [ ${#Squid[@]} -eq $count ]; then
	echo "Squid Proxy can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Squid Proxy can be accessed by ${Squid[@]}" | tee -a _test/results.txt
fi
if [ ${#WebDB[@]} -eq $count ]; then
	echo "Web Database can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Web Database can be accessed by ${WebDB[@]}" | tee -a _test/results.txt
fi
if [ ${#MailDB[@]} -eq $count ]; then
	echo "Mail Database can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Mail Database can be accessed by ${MailDB[@]}" | tee -a _test/results.txt
fi
if [ ${#HrDB[@]} -eq $count ]; then
	echo "HR Database can be accessed by all machines" | tee -a _test/results.txt
else
	echo "HR Database can be accessed by ${HrDB[@]}" | tee -a _test/results.txt
fi
if [ ${#StaffHR[@]} -eq $count ]; then
	echo "Staff HR Machine can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Staff HR Machine can be accessed by ${StaffHR[@]}" | tee -a _test/results.txt
fi
if [ ${#StaffCC[@]} -eq $count ]; then
	echo "Staff Corporate Comms Machine can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Staff Corporate Comms Machine can be accessed by ${StaffCC[@]}" | tee -a _test/results.txt
fi
if [ ${#StaffSA[@]} -eq $count ]; then
	echo "Staff System Admin Machine can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Staff System Admin Machine can be accessed by ${StaffSA[@]}" | tee -a _test/results.txt
fi
if [ ${#StaffFI[@]} -eq $count ]; then
	echo "Staff Finance Machine can be accessed by all machines" | tee -a _test/results.txt
else
	echo "Staff Finance Machine can be accessed by ${StaffFI[@]}" | tee -a _test/results.txt
fi
echo "Done" 1>&2
echo "Results can also be found in _test/results.txt" 1>&2
