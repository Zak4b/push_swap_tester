#!/bin/bash

GREEN="\033[32m"
BLUE="\033[34m"
RED="\033[31m"
YELLOW="\033[0;33m"
RESET="\033[0m"

echo -e "$BLUE"Push Swap tester"$RESET";

if [ $# -gt 2 ]; then
	echo -e "$RED"Usage: $0 \<PUSH_SWAP\> \<CHECKER\>"$RESET"
	exit 2
fi

PUSH_SWAP=${1:-./push_swap}
CHECKER=${2:-./checker}

if [ ! -x "$PUSH_SWAP" ]; then
	echo -e "$RED"Invalid Push Swap"$RESET"
	exit 2
fi

if [ $# -lt 2 ] && [ ! -f "$CHECKER" ]; then
	echo -e "$YELLOW"Downloading checker ..."$RESET";
	curl -L --fail -o checker https://github.com/Zak4b/push_swap_tester/raw/main/checker || {
		echo -e "$RED"Failed to download checker"$RESET"
		exit 1
	}
	chmod +x checker
fi
if [ ! -x "$CHECKER" ]; then
	echo -e "$RED"Invalid Checker"$RESET"
	exit 2
fi

is_positive_integer() {
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

random_values()
{
	if ! is_positive_integer "$1"; then
        return 1
    fi
	seq "$1" | shuf | tr '\n' ' '
}

push_swap_memtest()
{
	echo -e "$YELLOW"Memory test"$RESET";
	errors="";
	for ARG in "$@"; do
		valgrind_output=$( (valgrind --leak-check=full $PUSH_SWAP $ARG) 2>&1 >/dev/null );
		if [ -n "$(echo "$valgrind_output" | grep "ERROR SUMMARY: 0")" ]; then
			echo -ne "$GREEN""OK$RESET ";
		else
			echo -ne "$RED""KO$RESET ";
			errors="$errors\nKO with $ARG";
		fi
	done
	if [ -n "$errors" ]; then
		echo -e "$RED$errors$RESET";
		return 1
	else
		echo
		return 0
	fi
}

push_swap_nooutput()
{
	echo -e "$YELLOW"No output test"$RESET";
	errors="";
	for ARG in "$@"; do
		output=$($PUSH_SWAP $ARG 2>&1);
		if [ -z "$output" ]; then
			echo -ne "$GREEN""OK$RESET ";
		else
			echo -ne "$RED""KO$RESET ";
			errors="$errors\nKO with $ARG";
		fi
	done
	if [ -n "$errors" ]; then
		echo -e "$RED$errors$RESET";
		return 1
	else
		echo
		return 0
	fi
}

push_swap_test_with()
{
	errors="";
	for ARG in "$@"; do 
		result=$($PUSH_SWAP $ARG | $CHECKER $ARG);
		if [ "$result" = "OK" ]; then
			echo -ne "$GREEN$result$RESET ";
		else
			errors="$errors\nKO with $ARG";
		fi
	done
	if [ -n "$errors" ]; then
		echo -e "\n$RED$errors$RESET";
		return 1
	else
		echo
		return 0
	fi
}

push_swap_bench_with()
{
	total=0;
	max=0;
	min=999999;
	echo "Minimum: --";
    echo "Average: --";
    echo "Maximum: --";
	i=0;
	for ARG in "$@"; do
		i=$((i + 1));
		lines=$($PUSH_SWAP $ARG | wc -l);
		total=$((total + lines));
		if [ $lines -gt $max ]; then
			max=$lines;
		fi
		if [ $lines -lt $min ]; then
			min=$lines;
		fi
		tput cuu 3 
		average=$((total / $i));
		echo "Minimum: $min "
        echo "Average: $average "
        echo "Maximum: $max "
	done
	echo
}

generate_args()
{
	if ! is_positive_integer "$1"; then
		echo -e "$RED"Invalid size"$RESET" >&2;
		return 1
	fi
	if ! is_positive_integer "$2"; then
		echo -e "$RED"Invalid count"$RESET" >&2;
		return 1
	fi
	ARG=();
	for i in $(seq $2); do
		ARG+=("$(random_values "$1")");
	done
}

push_swap_bench()
{
	generate_args "$1" "$2" || return 1
	echo -e "$YELLOW"Performance on "$1" values"$RESET";
	push_swap_bench_with "${ARG[@]}"
}

push_swap_test()
{
	generate_args "$1" "$2" || return 1
	echo -e "$YELLOW"Testing "$1" values"$RESET";
	push_swap_test_with "${ARG[@]}"
	return $?
}

trap 'tput cnorm; echo -e "\n$RED""Operation interrupted $RESET"; exit' INT TERM
tput civis

push_swap_memtest "" "''" "1 2 1" "1 2 3 4 5 6 7 8 1" "1 2 a" "1q" "1 5 9 2 4" "1 3 2" "$(random_values 50)" "$(random_values 100)" "$(random_values 500)"
push_swap_nooutput "" "1" "1 2" "1 2 3" "1 2 3 4 5 6 7 8 9 10 11"

echo -e "$YELLOW"Testing 2 values"$RESET";
push_swap_test_with "1 2" "2 1"
echo -e "$YELLOW"Testing 3 values"$RESET";
push_swap_test_with "1 2 3" "1 3 2" "2 1 3" "2 3 1" "3 1 2" "3 2 1"
echo -e "$YELLOW"Testing 5 values"$RESET";
push_swap_test_with "1 2 3 4 5" "1 2 3 5 4" "1 2 4 3 5" "1 2 4 5 3" "1 2 5 3 4" "1 2 5 4 3" "1 3 2 4 5" "1 3 2 5 4" "1 3 4 2 5" "1 3 4 5 2" "1 3 5 2 4" "1 3 5 4 2" "1 4 2 3 5" "1 4 2 5 3" "1 4 3 2 5" "1 4 3 5 2" "1 4 5 2 3" "1 4 5 3 2" "1 5 2 3 4" "1 5 2 4 3" "1 5 3 2 4" "1 5 3 4 2" "1 5 4 2 3" "1 5 4 3 2" "2 1 3 4 5" "2 1 3 5 4" "2 1 4 3 5" "2 1 4 5 3" "2 1 5 3 4" "2 1 5 4 3" "2 3 1 4 5" "2 3 1 5 4" "2 3 4 1 5" "2 3 4 5 1" "2 3 5 1 4" "2 3 5 4 1" "2 4 1 3 5" "2 4 1 5 3" "2 4 3 1 5" "2 4 3 5 1" "2 4 5 1 3" "2 4 5 3 1" "2 5 1 3 4" "2 5 1 4 3" "2 5 3 1 4"
push_swap_test 100 20
push_swap_test 500 20

push_swap_bench 5 50
push_swap_bench 100 100
push_swap_bench 500 100
tput cnorm
