#!/usr/bin/env bash
# Copyright (C) 2015 <pcre@gmx.de>. All Rights Reserved.
# This file is licensed under the GPLv3+. Please see LICENSE for more information.

gorillacontainer="$1"
#User is used as leaf containting the password
leafUser="TRUE"
#Append URL to multiline password (Debian universe only)
multilineURL="FALSE"
#Append notes to multiline password
multilineNOTES="TRUE"
#Add an own entry url
entryURL="FALSE"

### Test the password gorilla export file ### 
# Password gorilla maintained by debian adds a header to the export file,
# because it also supports an import function. see (pass2gorilla).
# It also includes the url.
# There are two version of password gorilla export files:
# The debian universe and the rest of the unix universe.
yes="1!p"
no="p"
debianreg="uuid,group,title,url,user,password"
debian="uuid group title url user password notes"
rest="uuid group title user password notes"

#By default assume non Debian export file. Do not snip away the header.
snip="$no";
parse="$rest";
#Detect if debian header is set.
if egrep -q "$debianreg" <<< head -n1 "$gorillacontainer"; then
        snip="$yes";
        parse="$debian";
fi
### end of test ###

cat "$gorillacontainer" | sed -n "$snip" | while IFS="," read -r $parse; do

	group="$(sed -e 's/\\\./#/g' -e 's/\./\//g' -e 's/#/./g' <<< "$group")"
        title="$(sed -s 's/\s\{1,\}/_/g' <<< "$title")"

	if [[ $url != "" && $multilineURL == "TRUE" ]]; then password="$password\n$url"; fi
	if [[ $notes != "" && $multilineNOTES == "TRUE" ]]; then password="$password\n$notes"; fi

        entry="$group/$title";
        if [[ $user != "" && $leafUser == "TRUE" ]]; then
	    entry="$group/$title/$user"
        fi
	echo -e "$password" | pass insert --multiline --force "$entry"
	test $? && echo "Added! $entry"
	if [[ $url != "" && $entryURL == "TRUE" ]]; then
	    entry="$group/$title/url"
	    echo -e "$url" | pass insert --multiline --force "$entry"
            test $? && echo "Added! $entry"
        fi
done
