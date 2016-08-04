# This class should be considered private

class msktutil::params {
  $msktutilpath  = '/sbin/msktutil',
  $chmodpath     = '/bin/chmod',
  $configpath    = '/etc/krb5.conf',
  $keytabpath    = '/etc/krb5.keytab',
  $keytabmode    = '0600',
  $user          = 'root',
  $group         = 'root',
  $packagename   = 'msktutil',
  $usereversedns = false,
  $installed     = present,
  $updatehour    = '11',
}
