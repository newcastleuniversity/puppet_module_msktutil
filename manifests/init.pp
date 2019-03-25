# == Class: msktutil
#
# Manages Kerberos keytabs on Linux systems in Active Directory environments.
#
# You need to precreate the AD machine object.  See README.md for how
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
  Optional[Stdlib::Unixpath] $msktutilpath,
  Optional[Stdlib::Unixpath] $chmodpath,
  Optional[Stdlib::Unixpath] $configpath,
  Optional[Stdlib::Unixpath] $keytabpath,
  Optional[Stdlib::Filemode] $keytabmode,
  Optional[Integer] $keytabreplace,
  Optional[String] $user,
  Optional[String] $group,
  Optional[Array] $packages,
  Optional[Variant[Enum['true', 'false', 'yes', 'no'], Boolean] $usereversedns,
  Optional[Variant[Enum['true', 'false', 'yes', 'no', 'present', 'absent'], Boolean] $ensure,
  Optional[Variant[Enum['true', 'false', 'yes', 'no'], Boolean] $makekeytab,
  Optional[Variant[Enum['true', 'false', 'yes', 'no'], Boolean] $cron,
  Optional[Hash] $files
) {

  case $msktutil::usereversedns {
    'true', 'yes', true: { $dashn = '' }
    default:             { $dashn = '--no-reverse-lookups' }
  }

  # if the whole class is marked as absent:
  #   remove the package
  #   remove the cron files used by this distro
  #   disable keytab creation
  #   DO NOT remove keytab
  #   BREAK
  # if the class is marked as present (default):
  #   assume that keytab creation and management are enabled unless set otherwise
  #   install the package
  # if the class is present and keytab creation is marked as disabled
  #   disable keytab creation
  #   DO NOT remove keytab
  # if the class is present and keytab management is marked as disabled
  #   remove cron files used by this distro

  case $msktutil::ensure {
    'absent', 'no', 'false', false: {
      $realmakekeytab = false
      $realcron       = false
    }
    default: {
      $realmakekeytab = $makekeytab
      $realcron       = $cron
    }
  }

  anchor { 'msktutil::begin': }
  anchor { 'msktutil::end': }
  include msktutil::install
  include msktutil::keytab
  include msktutil::cron

  Anchor['msktutil::begin']
    -> Class['msktutil::install']
    -> Class['msktutil::keytab']
    -> Class['msktutil::cron']
  -> Anchor['msktutil::end']

}
