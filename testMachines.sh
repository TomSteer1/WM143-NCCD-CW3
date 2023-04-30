#!/bin/bash
echo "Removing previous tests" 1>&2
rm _test/*.txt 2>/dev/null
echo "Starting machines" 1>&2
lstart --tmux-detached
echo "Machines started" 1>&2
echo "Getting list of machines" 1>&2
machines=$(vconnect -l | awk '{print $1}')
for machine in $machines; do
	# Rempve colon from machine name
	machine=${machine%:}
	echo "Testing $machine" 1>&2
	vcommand $machine "/root/test.sh" > /dev/null
done
echo "All machines tested" 1>&2
echo "Waiting for machines to finish" 1>&2
# Wait for number of machines to equal number of files in _test
while [ $(ls _test | wc -l) -ne $(vconnect -l | wc -l) ]; do
	sleep 1
done
echo "Stopping machines" 1>&2
lcrash
echo "Machines stopped" 1>&2
echo "Results are:" 1>&2
for machine in $machines; do
	# Rempve colon from machine name
	machine=${machine%:}
	echo "$machine: $(cat _test/$machine.txt)" 1>&2
done
