# @summary Manages Kerberos keytabs on Linux systems in Active Directory environments.
#
# You need to precreate the AD machine object.  See README.md for how
#
# === Authors
#
# Helen Griffiths, John Snowdon
#
# === Copyright
#
# Copyright 2016-22 University of Newcastle
#
# @param chmodpath Full path to chmod binary on your system.
# @param configpath Full path to krb5.conf.
# @param cronfiles The list of files needed to install a daily cronjob on your system.
# @param enablecron Whether to enable the msktutil keytab rotation cronjob.
# @param ensure Remove (false) or install (true) everything controlled by this module.
# @param extraopts Extra options given to msktutil to cope with your AD controller and DNS, e.g. extra service principals.
# @param group Group owner of the system keytab.
# @param keytabmode File mode of system keytab.
# @param keytabpath File path of system keytab.
# @param keytabreplace How many days old the system keytab is before it is replaced.
# @param makekeytab Attempt (true) or don't attempt (false) to join the domain, which makes a keytab in the process.
# @param msktutilpath Full path to msktutil binary on your system.
# @param packages List of packages needed to obtain msktutil.
# @param usereversedns Whether to use reverse DNS wehn rotating the keytab.
#
class msktutil (
  Optional[Stdlib::Unixpath] $msktutilpath,
  Optional[Stdlib::Unixpath] $chmodpath,
  Optional[Stdlib::Unixpath] $configpath,
  Optional[Stdlib::Unixpath] $keytabpath,
  Optional[Stdlib::Filemode] $keytabmode,
  Optional[Integer] $keytabreplace,
  Optional[String] $group,
  Optional[Array] $packages,
  Optional[Variant[Enum['yes', 'no'], Boolean]] $usereversedns,
  Optional[Variant[Enum['yes', 'no', 'present', 'absent'], Boolean]] $ensure,
  Optional[Variant[Enum['yes', 'no'], Boolean]] $makekeytab,
  Optional[Variant[Enum['yes', 'no'], Boolean]] $enablecron,
  Optional[Hash[String, Hash]] $cronfiles,
  Optional[String] $extraopts
) {
  case $msktutil::usereversedns {
    'yes', true: { $dashn = '' }
    default: { $dashn = '--no-reverse-lookups' }
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
    'absent', 'no', false: {
      $realmakekeytab = false
      $realcron       = absent
    }
    default: {
      $realmakekeytab = $msktutil::makekeytab
      case $msktutil::enablecron {
        'no', false: {
          $realcron = absent
        }
        default: {
          $realcron = file
        }
      }
    }
  }

  contain msktutil::install
  contain msktutil::keytab
  contain msktutil::cron

  Class['msktutil::install']
  -> Class['msktutil::keytab']
  -> Class['msktutil::cron']
}
