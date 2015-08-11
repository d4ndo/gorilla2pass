#!/usr/bin/env bash
# Copyright (C) 2015 <pcre@gmx.de>. All Rights Reserved.
# This file is licensed under the GPLv3+. Please see LICENSE for more information.

gorillacontainer="$1"
#Append Title to Group
appendTitle="TRUE"

#"uuid,group,title,url,user,password,notes"
cat "$gorillacontainer" | sed -n '1!p' | while IFS="," read -r uuid group title url user password notes; do

	group="$(sed -e 's/\\\./#/g' -e 's/\./\//g' -e 's/#/./g' <<< "$group")"
	title="$(sed -e 's/$/\//' <<< "$title")"

	test "$notes" != "" && password="$password $notes"
	entry="$group/$user"
	test "$appendTitle" = "TRUE" && entry="$group/$title/$user" 

	echo "$password" | pass insert --multiline --force $entry
	test $? && echo "Added! $entry"	
done
