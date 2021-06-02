# Instructions

- Install git and clone this repository.
- Create a branch `abis` and check it out.
- Create a `data` directory and create a new empty file `common.yaml` in it.
- Commit your changes.

## Start playing with Puppet Bolt

- [Install Puppet Bolt](https://puppet.com/docs/bolt/latest/bolt_installing.html#install-bolt-on-rhel).
- Determine the host name of your target node by issuing the command `hostname`.

## Install ABIS Backend

- cd into the `installer` directory of the ABIS Backend release.
- Inspect available plans and tasks. Issuing `bolt help` may give some hints.

Install ABIS Backend including WebABIS NIST Extension:

```
bolt plan run abis_install::standalone role=<which one is it?> -t <target host> -u root
```

### Check system state

```
bolt command run 'abis_systemcheck.sh' -t <target host> -u root
```

## Reconfigure the target node to use the training license server

Hint: Add missing parameter to the common.yaml and commit the change prior applying.

Parameter:

dafis_wibu::wibu_server: '<host serving licenses>'

Hint: Use plan `abis_tools::prepare_environment_data`.

Apply changes with task `abis_tools::agent`

## Reconfigure the target node to use Oracle instead of MariaDB for data persistence

### Prepare db schemata

Example:

```
ALTER SYSTEM SET DB_CREATE_FILE_DEST = '/u01/app/oracle/oradata/ORCLCDB';
create tablespace ABIS;
create tablespace ABIS_IDX;
create tablespace ABIS_LOB;

-- USER SQL --
CREATE USER "BIOMETRICSTORE" IDENTIFIED BY "biometricstore"
    DEFAULT TABLESPACE "ABIS"
    TEMPORARY TABLESPACE "TEMP";

-- QUOTAS --
ALTER USER "BIOMETRICSTORE" QUOTA UNLIMITED ON ABIS;
ALTER USER "BIOMETRICSTORE" QUOTA UNLIMITED ON ABIS_IDX;
ALTER USER "BIOMETRICSTORE" QUOTA UNLIMITED ON ABIS_LOB;

-- ROLES AND PERMISSIONS --
GRANT CREATE SESSION TO "BIOMETRICSTORE";
GRANT "CONNECT" to "BIOMETRICSTORE";
GRANT "RESOURCE" to "BIOMETRICSTORE";

-- USER SQL --
CREATE USER "WEBABIS" IDENTIFIED BY "webabis"
    DEFAULT TABLESPACE "ABIS"
    TEMPORARY TABLESPACE "TEMP";

-- QUOTAS --
ALTER USER "WEBABIS" QUOTA UNLIMITED ON ABIS;
ALTER USER "WEBABIS" QUOTA UNLIMITED ON ABIS_IDX;
ALTER USER "WEBABIS" QUOTA UNLIMITED ON ABIS_LOB;

-- ROLES AND PERMISSIONS --
GRANT CREATE SESSION TO "WEBABIS";
GRANT "CONNECT" to "WEBABIS";
GRANT "RESOURCE" to "WEBABIS";
```

### Adjust config and reapply

- Merge origin/with_oracle into branch abis.
- Adjust the access parameters and commit the modifications.
- Apply the changes as in the previous chapter.

## Reconfigure sizing for up to 10.000 records

Add this to the common.yaml and reapply the changes.

```
# Assuming 800M total RAM for 10K records (face, tenprints, iris)
# Assuming 4 cores with 2 threads
abis_dispatcher::nr_of_galleries: 8
# 100M per gallery
abis_dispatcher::satellite_gallery_size: 100
```

## Git introduction

[git - the simple guide](https://rogerdudler.github.io/git-guide/)
https://www.atlassian.com/git/tutorials

[Pro Git Buch](https://git-scm.com/book/en/v2)

### Recommended settings

### Global settings

```
git config --global user.name $(whoami)
git config --global user.email "Your DERMALOG Mailaddress"
git config --global pull.rebase true
git config --global status.submodulesummary true
git config --global fetch.recursesubmodules true
git config --global tag.sort version:refname
git config --global color.status auto
git config --global color.branch auto
git config --global color.ui auto
git config --global remote.origin.prune true
git config --global push.followTags true
```

### For Windows

```
git config --global core.autocrlf true
```

### Global .gitignore

```
cat << EOF > ~/.gitignore
.cproject
.project
*.user
.*.swp
.settings
.autotools
build/
*.orig
*~
.pydevproject
compile_commands.json
.idea/
cmake-build-*/
**/jmeter.log
jmeter/out/*
**/lextab.py
**/yacctab.py
*.srctrlbm
*.srctrldb
*.srctrlprj
.vscode/
*.iml
target/
EOF
```

```
git config --global core.excludesfile ~/.gitignore .
```

### Best Practices

#### Git Commit Message

Put an empty line after the first line containing a short description of the content.

```
TICKET_ID: Add the summary in the first line.

Add some more details about the changes in this commit after the empty line above.
```

[See Contributing to a project](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project).

#### Aliases für die Bash

For Windows and for Linux you can maintain shortcut aliases for often used Git commands in your `~/.bashrc`:

```
# User specific aliases and functions
alias st='git status'
alias com='git commit'
alias commit='git commit'
alias addu='git add -u'
alias add='git add'
alias pr='git push origin HEAD:refs/for/master'
alias pull='git pull; git submodule update --init --recursive'
alias ame='git commit --amend'
alias stash='git stash'
alias review='git review'
alias checkout='git checkout'
alias co='git checkout'
alias update='git submodule update --init --recursive'
alias br='git branch'
```
