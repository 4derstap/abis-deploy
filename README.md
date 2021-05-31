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

## Reconfigure the target node to use the training license server

Hint: Add missing parameter to the common.yaml and commit the change prior applying.

Parameter:

dafis_wibu::wibu_server: '<host serving licenses>'

Hint: Use plan `abis_tools::prepare_environment_data`.

Apply changes with task `abis_tools::agent`

## Reconfigure the target node to use Oracle instead of MariaDB for data persistence

- Merge origin/with_oracle into branch abis.
- Adjust the access parameters and commit the modifications.
- Apply the changes as in the previous chapter.
