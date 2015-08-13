# gorilla2pass

convert a password gorilla container to a pass repository.

##Getting started:

First thing to do is to export the password gorilla container to an csv file.

Initialise pass as usual:

```bash
pass init user@mydomain.com
```
then run the script:

```bash
./gorilla2pass.sh ex.csv
shred -u ex.csv
```

##Organisation 

gorilla2pass.sh is appending the ```title``` as subdirectory. Assuming that the ```title``` is containing the url e.G. ```github.com```, then the output would look something like this:

```bash
├── email
│   ├── google.com
│   │   ├── user1@gmail.com
│   │   └── spaminside@gmail.com
│   └── mydomain.com
│       └── foo
├── github.com
│   └── nickname
├── openstreetmap.org
│   └── user@gmail.com
├── ssh
│   ├── mydomain.de
│   │   ├── user1
│   │   └── user2
│   └── github.com
│       └── user1
[..]
```

My favorite organisation : Parent dir holding the url. Username containing the password. 

Any information stored as ```notes``` is added as multiline password:

+ first line = password, 
+ underneath = notes.

##Configuration

To change the organisation structure a bit, the following flags can be modified:

```bash
  #Append Title to Group path
  appendTitle="TRUE"
  #Append URL to multiline password
  multilineURL="FALSE"
  #Append notes to multiline password
  multilineNOTES="TRUE"
```

##See also

https://github.com/d4ndo/pass2gorilla
