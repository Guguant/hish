#!/bin/bash
#
# (c) 2021, Sun Yiming <zscandyz@gmail.com>
#
# This script is a tool that it can check
# code spelling mistakes and typos automatically.
#
# usage: put the 'spelling.txt' and 'run_spelling_typo_check.sh'
#        under the same directory, and then
#        Run 'run_spelling_typo_check.sh'
#
# version:
# 2021/03/02, v1.0, first release, Sun Yiming
# 2021/03/17, v2.0, optimize output result, Sun Yiming 
#
# test datasets:
#   https://github.com/torvalds/linux/blob/master/scripts/spelling.txt

input=spelling.txt
output=result.txt

if [ -f "$output" ]; then
	> $output
else
	touch $output
fi

line_sum=`awk 'END {print NR}' $input`
typo_sum=0
index=0

while read line
do
	echo "[$index/$line_sum] : $line"

	keyword=${line%%|*}
	temp_grep_result=""
	temp_grep_result=$(grep -rsnwi $keyword --exclude $input)

	if [ "$temp_grep_result" != "" ]; then
		echo ">>>>>> $keyword is matched!"

		echo $line [$index/$line_sum] >> $output
		echo "====================" >> $output
		echo $temp_grep_result >> $output
		echo >> $output

		((typo_sum++))
	fi

	((index++))
done < ${input}

echo ""
echo "####################"
echo "typo_sum=$typo_sum"
echo "####################"