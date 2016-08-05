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
  $msktutilpath  = $msktutil::param::msktutilpath,
  $chmodpath     = $msktutil::param::chmodpath,
  $configpath    = $msktutil::param::configpath,
  $keytabpath    = $msktutil::param::keytabpath,
  $keytabmode    = $msktutil::param::keytabmode,
  $user          = $msktutil::param::user,
  $group         = $msktutil::param::group,
  $packagename   = $msktutil::param::packagename,
  $usereversedns = $msktutil::param::usereversedns,
  $installed     = $msktutil::param::installed,
  $updatehour    = $msktutil::param::updatehour,
) inherits msktutil::param {

  Anchor['msktutil::begin'] ->
    Class['msktutil::install'] ->
    Class['msktutil::config']  ->
    Class['msktutil::service'] ->
  Anchor['msktutil::end']
  
}
