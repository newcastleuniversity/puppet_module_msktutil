# Class: msktutil

Manages Kerberos keytabs on Linux systems in Active Directory environments.

## Authors

Helen Griffiths <helen.griffiths@newcastle.ac.uk>

## Copyright

Copyright 2016 University of Newcastle

## Usage

1. Precreate the computer account in Active Directory and add to it any unusual service principals that you might need.  You might also need to alter the FQDN of the host within AD to be *```yourmachine```*```.ncl.ac.uk```
2. Reset the precreated computer account.
3. Ensure you have the Advanced Mode active in the AD management console - right click on the computer object and select Attribute Editor
4. Scroll to the dNSHostName attribute and enter the hostname of the machine, e.g.: machinename99
5. Scroll to the servicePrincipleName attribute and enter the FQDN of the machine prefixed by host/, e.g.: host/machinename99.ncl.ac.uk

*end here if not using Puppet to manage the host*

6. (Optional if using Puppet) Create, using Puppet or otherwise, a suitable Kerberos config file to use with your AD.  I recommend that you test this (e.g. by running "kinit" to get a ticket) as this module assumes that a valid Kerberos config exists.
7. (Optional) Create a group to grant read access to the keytab and add service accounts (e.g. apache) to it.
8. Install this module into your puppet master.
9. Include this module if the default params in the param.pp file work for you, or declare it with overrides.
10. If you want/need to run the command to generate the keytab manually run it as: msktutil --verbose -N --create --computer-name `hostname`

## Distribution-specific oddities

Redhat derivatives need to have the EPEL repository enabled.

## Parameters

Default values in param.pp

| Parameter      | Type                      | Purpose                                                                                                                                                                                                |
|----------------|---------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| $msktutilpath  | String                    | Sets full path to msktutil binary.                                                                                                                                                                     |
| $chmodpath     | String                    | Sets full path to chmod binary.                                                                                                                                                                        |
| $configpath    | String                    | Sets full path to Kerberos config file.                                                                                                                                                                |
| $keytabpath    | String                    | Sets full path to Kerberos machine keytab.                                                                                                                                                             |
| $keytabmode    | Octal as a string         | Sets Unix permissions over the keytab.                                                                                                                                                                 |
| $user          | String                    | Sets user owner of the keytab.                                                                                                                                                                         |
| $group         | String                    | Sets group owner of the keytab. Set to an override for use with usage step 4 above.                                                                                                                    |
| $packagename   | String                    | Sets the package name according to your distribution.                                                                                                                                                  |
| $usereversedns | Boolean                   | Turns on or off the use of reverse DNS when obtaining tickets from the AD controller. Useful in environments where the AD controller and site DNS server don't agree on the FQDNs of Kerberos clients. |
| $ensure        | "present" or "absent"     | Whether to install msktutil or not.  Removes the keytab as well as the package and cron job if set to absent.                                                                                          |
| $updatehour    | Integers 0-23 as a string | When, each day, to check for imminent expiry of the keytab and update it accordingly.                                                                                                                  |
