#!/usr/bin/env bash
# Copyright (C) 2015 <pcre@gmx.de>. All Rights Reserved.
# This file is licensed under the GPLv3+. Please see LICENSE for more information.

gorillacontainer="$1"
#Append Title to Group path
appendTitle="TRUE"
#Append URL to multiline password
multilineURL="FALSE"
#Append notes to multiline password
multilineNOTES="TRUE"

#"uuid,group,title,url,user,password,notes"
cat "$gorillacontainer" | sed -n '1!p' | while IFS="," read -r uuid group title url user password notes; do

	group="$(sed -e 's/\\\./#/g' -e 's/\./\//g' -e 's/#/./g' <<< "$group")"
	title="$(sed -e 's/$/\//' <<< "$title")"

	if [[ $url != "" && $multilineURL == "TRUE" ]]; then password="$password\n$url"; fi
	if [[ $notes != "" && $multilineNOTES == "TRUE" ]]; then password="$password\n$notes"; fi
	entry="$group/$user"
	test "$appendTitle" = "TRUE" && entry="$group/$title/$user"

	echo -e "$password" | pass insert --multiline --force $entry
	test $? && echo "Added! $entry"
done
