#!/bin/sh

#sets dir to directory containing this script
dir=`dirname $0`

#use $dir/ as prefix to run any programs in this dir
#so that this script can be run from any directory.

parser_code_path=$HOME/projects/i571c/submit/prj1-sol
python3 $parser_code_path/desig_init.py
