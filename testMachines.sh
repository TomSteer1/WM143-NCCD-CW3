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
#Wait for number of machines to equal number of files in _test
while [ $(ls _test | wc -l) -ne $(vconnect -l | wc -l) ]; do
	sleep 1
done
echo "Stopping machines" 1>&2
lcrash 1>/dev/null
echo "Machines stopped" 1>&2
echo "Parsing results" 1>&2
# Parse Results into arrays of machine names each represented by a bit in the result
outputs=()
machineNames=("External Web Server" "External DNS Server" "Internal Web Server" "Mail Server" "LDAP Server" "Internal DNS Server" "Squid Proxy" "Web Database" "Mail Database" "HR Database" "Staff HR Machine" "Staff CC Machine" "Staff SA Machine" "Staff FI Machine" "OpenVPN Server" "Staff Printer")
length=${#machineNames[@]}
for machine in $machines; do
	machine=${machine%:}
	result=$(cat _test/$machine.txt)
	for (( j=0; j<${length}; j++ ));
	do
		if [ ${result:$j:1} -eq 1 ]; then
			outputs[$j]="${outputs[$j]}$machine "
		fi
	done
done

echo "Test run on ${#machines[@]} machines" > _test/results.txt
echo "The following services can be accessed by:" | tee _test/results.txt
for (( j=0; j<${length}; j++ ));
do
	echo "${machineNames[$j]}: ${outputs[$j]}" | tee -a _test/results.txt
done

# Pings what each machine can ping
echo "Pinging machines" | tee -a _test/results.txt
machineNames=("Ext-DNS" "Ext-Office" "Ext-WWW" "Database" "Int-DNS" "Internal WWW" "LDAP" "Mail" "OpenVPN" "Squid" "Staff-CC" "Staff-FI" "Staff-HR" "Staff-SA" "Staff-Printer")
length=${#machineNames[@]}
for machine in $machines; do 
	machine=${machine%:}
	result=$(cat _test/$machine.txt)
	pings="" 
	offset=16
	for (( j=0; j<${length}; j++ ));
	do
		if [ ${result:$j+$offset:1} -eq 1 ]; then
			pings+="${machineNames[$j]} "
		fi
	done
	if [ ${#pings} -ne 0 ]; then
		echo "$machine can ping: ${pings}" | tee -a _test/results.txt
	fi
done


echo "Done" 1>&2
echo "Results can also be found in _test/results.txt" 1>&2
