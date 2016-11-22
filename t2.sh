#!/bin/bash
echo 'Shall we begin the deom?(y/n)'
read ANS
echo 'begin...'

A=0
declare -a B=(0)
if [ $ANS = 'y' ]
then 
	echo 'Output the results of while loop'
	while [ $A -lt 10 ]
	do 
		echo $A
		A=`expr $A + 1`
		B=(${B[*]} $A)
	done
else echo 'Not ready for the demo yet'
fi

echo 'Output the results of the for loop.'
for I in ${B[*]}
	do 
		echo $I
	done

echo `date`

hello(){
	echo "Hello $1 $2!"
	A=`expr 5 \* 10`
	return $A
}

hello 'world' 'asf111'
RET=$?
echo ${RET}

