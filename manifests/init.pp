# == Class: msktutil
#
# Manages Kerberos keytabs on Linux systems in Active Directory environments.
#
# See README.md
#
# === Authors
#
# Helen Griffiths <helen.griffiths@newcastle.ac.uk>
#
# === Copyright
#
# Copyright 2016 University of Newcastle
#

class msktutil (
  $msktutilpath,
  $chmodpath,
  $configpath,
  $keytabpath,
  $keytabmode,
  $user,
  $group,
  $packagename,
  $usereversedns,
  $ensure,
  $ensurecron,
  $myhostname,
  $keytabreplace
) {

  anchor { 'msktutil::begin': }
  anchor { 'msktutil::end': }
  include msktutil::install
  include msktutil::service

  Anchor['msktutil::begin']
    -> Class['msktutil::install']
    -> Class['msktutil::service']
  -> Anchor['msktutil::end']

}
