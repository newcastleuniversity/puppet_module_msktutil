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
  $msktutilpath  = $msktutil::params::msktutilpath,
  $chmodpath     = $msktutil::params::chmodpath,
  $configpath    = $msktutil::params::configpath,
  $keytabpath    = $msktutil::params::keytabpath,
  $keytabmode    = $msktutil::params::keytabmode,
  $user          = $msktutil::params::user,
  $group         = $msktutil::params::group,
  $packagename   = $msktutil::params::packagename,
  $usereversedns = $msktutil::params::usereversedns,
  $installed     = $msktutil::params::installed,
  $updatehour    = $msktutil::params::updatehour,
) inherits msktutil::params {

  anchor { 'msktutil::begin': }
  anchor { 'msktutil::end': }

  Anchor['msktutil::begin'] ->
    Class['msktutil::install'] ->
    Class['msktutil::config']  ->
    Class['msktutil::service'] ->
  Anchor['msktutil::end']
  
}
