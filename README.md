# Class: msktutil

Manages Kerberos keytabs on Linux systems in Active Directory environments.

## Authors

Helen Griffiths <helen.griffiths@newcastle.ac.uk>

## Copyright

Copyright 2016-19 University of Newcastle

## Usage

First, precreate the AD account object for the new PC.

If you use a managed Linux workstation:

```Shell
# kinit tickets with an s-id.
kinit sabc123

# run this with modifications.
# wrap this in a loop to create many new machine accounts.
/usr/sbin/msktutil \
  --precreate \
  --computer-name $pi \
  --hostname $pi.ncl.ac.uk \
  --user-creds-only \
  --service host/$pi.ncl.ac.uk \
  --service host/$pi.campus.ncl.ac.uk \
  --service host/$pi \
  --no-reverse-lookups \
  --description 'Flat floor Pi. Raspbian Stretch, managed with Puppet 5.' \
  --base 'OU=Flat_Floor_Pis,OU=Linux,OU=Workstation,OU=D-COMP,OU=SAgE_Schools_and_Units,OU=SAgE_Faculty,OU=Departments'
```

Replace $pi and description and base.

If you use a Windows PC:

1. Precreate the computer account in Active Directory and add to it any unusual service principals that you might need.  You might also need to alter the FQDN of the host within AD to be *```yourmachine```*```.ncl.ac.uk```
2. Reset the precreated computer account.
3. Ensure you have the Advanced Mode active in the AD management console - right click on the computer object and select Attribute Editor
4. Scroll to the dNSHostName attribute and enter the FQDN of the machine, e.g.: machinename99.ncl.ac.uk
5. Scroll to the servicePrincipleName attribute and enter the FQDN of the machine prefixed by host/, e.g.: host/machinename99.ncl.ac.uk

Creating Powershell to do the above is left as an exercise for the reader.

## Distribution-specific oddities

Redhat derivatives need to have the EPEL repository enabled.

## New parameters

### $ensure
- whether to install and manage msktutil at all.
- True or false, present or absent

### $makekeytab
- whether to make or remove the keytab.
- True or false, present or absent

### $cron
- whether to manage keytab rotation.
- True or false, present or absent

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
