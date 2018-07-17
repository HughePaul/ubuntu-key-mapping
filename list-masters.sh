#!/bin/bash

for project in ~/projects/*/.git ~/projects/config/*/.git; do
	project="$(dirname "$project")"
	cd "$project"

	branch="$(git status --porcelain -b | grep '^##' | cut -b 4- | cut -d'.' -f1)"
	dirty="$(git status --porcelain -b | grep -qv '^##' && echo DIRTY)"

	if test "$branch" == "master"; then
		echo -n "-"
	else 
		echo -n "\\"
	fi

	if test -n "$dirty"; then
		echo -n "#"
	else
		echo -n "O"
	fi

	echo -n " $project"

	if test "$branch" != "master"; then
		echo -n " [$branch]"
	fi

	echo
done