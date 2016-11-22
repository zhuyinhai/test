#!/bin/bash
cd files
FILE=test-1.txt

sed -i.tmp "/^$/d" $FILE

sed -e "/^$/d" test-2.txt
echo '\\n'
r=`sed -e "/^$/d" test-2.txt`
echo "${r}"
echo "${r}" >> r.txt

# sed -i.tmp 's/[^.]$/;/' 'test-3.txt'

sed -i '.tmp' '$a\
 ' test-3.txt
sed -i '.tmp' '$a\ 
---' test-3.txt
sed -i '.tmp' '$a\' test-3.txt
#echo "---" >> test-3.txt
sed -i '.tmp' '$a\
just some random text in the last line' test-3.txt
