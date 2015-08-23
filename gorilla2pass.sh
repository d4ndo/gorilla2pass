#!/usr/bin/env bash
# Copyright (C) 2015 <pcre@gmx.de>. All Rights Reserved.
# This file is licensed under the GPLv3+. Please see LICENSE for more information.

gorillacontainer="$1"
#User is used as leaf containting the password
leafUser="TRUE"
#Append URL to multiline password
multilineURL="FALSE"
#Append notes to multiline password
multilineNOTES="TRUE"
#Add an own entry url
entryURL="FALSE"

#"uuid,group,title,url,user,password,notes"
cat "$gorillacontainer" | sed -n '1!p' | while IFS="," read -r uuid group title url user password notes; do

	group="$(sed -e 's/\\\./#/g' -e 's/\./\//g' -e 's/#/./g' <<< "$group")"
        title="$(sed -s 's/\s\{1,\}/_/g' <<< "$title")"

	if [[ $url != "" && $multilineURL == "TRUE" ]]; then password="$password\n$url"; fi
	if [[ $notes != "" && $multilineNOTES == "TRUE" ]]; then password="$password\n$notes"; fi

        entry="$group/$title";
        if [[ $user != "" && $leafUser == "TRUE" ]]; then
	    entry="$group/$title/$user"
        fi
	echo -e "$password" | pass insert --multiline --force $entry
	test $? && echo "Added! $entry"
	if [[ $url != "" && $entryURL == "TRUE" ]]; then
	    entry="$group/$title/url"
	    echo -e "$url" | pass insert --multiline --force $entry
            test $? && echo "Added! $entry"
        fi
done
