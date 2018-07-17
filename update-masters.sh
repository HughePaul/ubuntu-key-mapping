#!/bin/bash
. ~/.nvm/nvm.sh
for project in ~/projects/*/.git ~/projects/config/*/.git; do

	project="$(dirname "$project")"
	cd "$project"

	branch="$(git status --porcelain -b | grep '^##' | cut -b 4- | cut -d'.' -f1)"
	dirty="$(git status --porcelain -b | grep -qv '^##' && echo DIRTY)"

	if test "$branch" == "master"; then
		echo -n " "
	else 
		echo -n "\\"
	fi

	if test -n "$dirty"; then
		echo -n "#"
	else
		echo -n " "
	fi

	echo -n " $project"

	if test "$branch" != "master"; then
		echo " [BRANCH $branch]"
	elif test "$branch" == "master" && test -n "$dirty"; then
		echo " [DIRTY]"
		git status --porcelain -b
	else
		echo " [updating]"
		git fetch --all -q -p
		git pull -q -p
		test -f package.json && \
		test "$(stat -c%Y package.json)" '>' "$(stat -c%Y node_modules/)" && (
			echo " - Reinstalling node modules"
			nodeversion="$(test -f .node-version && cat .node-version)"
			nvm use "${nodeversion:-8.9.4}"
			rm -rf node_modules > /dev/null
			set -e
			npm install -s > /dev/null
			set +e
			npm prune > /dev/null
			git reset --hard HEAD
		)
	fi

done