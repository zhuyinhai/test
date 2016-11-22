#!/bin/bash
NAME='stenve'
echo "my name is ${NAME}, the first tow words is ${NAME:0:2}"
echo 'here is $50'
echo "here is $50"
declare -a NAMES=('aaaiasdfsadf', 'bbb', 'ccc')
echo ${NAMES[0]}
echo ${NAMES[1]}
echo ${NAMES[*]}
echo ${#NAMES[*]}
echo ${#NAMES}
NAMES=("${NAMES[*]}" "ddd")
echo ${NAMES[*]}
expr 2 + 2
VAR=5
expr 2 + 5
expr 2 \* 12
A=4
B=5
let add=$A+$B
echo add
A=10
B=15
if [ $A -eq $B ]
then
	echo 'True'
else 
	echo 'False'
fi

if [ $A -lt 8 ] && [ $B > 8 ]
then 
	echo 'true'
else 
	echo 'false'
fi








