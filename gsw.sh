#!/bin/bash

case "$1" in
	setup)
		read -p "User name: "		USERNAME
		read -p "User email: "		USEREMAIL
		read -p "Editor: "		COREEDITOR
		read -p "Default branch: "	INITDEFAULTBRANCH

		git config --global user.name		"$USERNAME"
		git config --global user.email		"$USEREMAIL"
		git config --global core.editor		"$COREEDITOR"
		git config --global init.defaultBranch	"$INITDEFAULTBRANCH"
		exit 0
		;;
	add)
		MAJOR=$(git log -1 --pretty=format:%s | cut -d. -f1)

		case "$2" in
			release)
				if [ $MAJOR = 0 ] && [ -n "$3" ]
				then
					git add -A
					git commit -m "1.0.0" -m "break: $3" --allow-empty
					exit 0
				fi
				echo Not dev version
				;;
			break)
				if [ $MAJOR = 0 ] && [ -n "$3" ]
				then
					DEV_MAJOR=$(git log -1 --pretty=format:%s | cut -d. -f2)
					DEV_MAJOR=$((DEV_MAJOR + 1))

					git add -A
					git commit -m "$MAJOR.$DEV_MAJOR.0.0" -m "break: $3" --allow-empty
					exit 0
				elif [ -n "$3" ]
				then
					MAJOR=$((MAJOR + 1))

					git add -A
					git commit -m "$MAJOR.0.0" -m "break: $3" --allow-empty
					exit 0
				fi
				;;
			feat)
				if [ $MAJOR = 0 ] && [ -n "$3" ]
				then
					DEV_MAJOR=$(git log -1 --pretty=format:%s | cut -d. -f2)
					DEV_MINOR=$(git log -1 --pretty=format:%s | cut -d. -f3)
					DEV_MINOR=$((DEV_MINOR + 1))

					git add -A
					git commit -m "$MAJOR.$DEV_MAJOR.$DEV_MINOR.0" -m "feat: $3" --allow-empty
					exit 0
				elif [ -n "$3" ]
				then
					MINOR=$(git log -1 --pretty=format:%s | cut -d. -f2)
					MINOR=$((MINOR + 1))

					git add -A
					git commit -m "$MAJOR.$MINOR.0" -m "feat: $3" --allow-empty
					exit 0
				fi
				;;
			fix)
				if [ $MAJOR = 0 ] && [ -n "$3" ]
				then
					DEV_MAJOR=$(git log -1 --pretty=format:%s | cut -d. -f2)
					DEV_MINOR=$(git log -1 --pretty=format:%s | cut -d. -f3)
					DEV_FIXED=$(git log -1 --pretty=format:%s | cut -d. -f4)
					DEV_FIXED=$((DEV_FIXED + 1))

					git add -A
					git commit -m "$MAJOR.$DEV_MAJOR.$DEV_MINOR.$DEV_FIXED" -m "fix: $3" --allow-empty
					exit 0
				elif [ -n "$3" ]
				then
					MINOR=$(git log -1 --pretty=format:%s | cut -d. -f2)
					FIXED=$(git log -1 --pretty=format:%s | cut -d. -f3)
					FIXED=$((FIXED + 1))

					git add -A
					git commit -m "$MAJOR.$MINOR.$FIXED" -m "fix: $3" --allow-empty
					exit 0
				fi
				;;
		esac
		;;
	create)
		rm -rf .git
		git init
		git add -A
		git commit -m "0.0.0.0" -m "break: init" --allow-empty
		exit 0
		;;
	forgive)
		git reset --hard
		git clean -fd
		;;
	connect)
		case $2 in
			erase!)
				if [ -n "$3" ]
				then
					git remote add origin $3
					git branch -M main
					git push -u origin main --hard
					exit 0
				fi
				;;
			remote)
				if [ -n "$3" ]
				then
					git clone "$3" .
					exit 0
				fi
				;;
		esac
		;;
	prod!)
		git push
		exit 0
		;;
esac

echo Wrong usage
exit 1
