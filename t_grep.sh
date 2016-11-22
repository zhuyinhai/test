#!/bin/bash
cd files
ls
grep "fff$" -n test-*.txt
grep "file\|line" -n test-*.txt
echo '------'
grep 'file.' -n test-*.txt
echo '------'
grep 'file\.' -n test-*.txt
