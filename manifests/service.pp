class msktutil::service (
  $msktutilpath  = $::msktutil::params::msktutilpath,
  $packagename   = $::msktutil::params::packagename,
  $usereversedns = $::msktutil::params::usereversedns,
  $user          = $::msktutil::params::user,
  $group         = $::msktutil::params::group,
  $chmodpath     = $::msktutil::params::chmodpath,
  $keytabmode    = $::msktutil::params::keytabmode,
  $keytabpath    = $::msktutil::params::keytabpath
  $installed     = $::msktutil::params::installed
) inherits ::msktutil {

  if $installed == absent {
    file { "${keytabpath}":
      ensure => absent,
    }
  } else {

    case $usereversedns {
      true:    { $dashn = '' }
      default: { $dashn = '-N' }
    }

    exec { 'msktutil':
      command => "${msktutilpath} ${dashn} --create",
      creates => "${keytabpath}",
      user    => $user,
      group   => $group,
      unless  => $installed 
      notify  => Exec['keytabperms'],
    }
    
    exec { 'keytabperms':
      command => "${chmodpath} ${keytabmode} ${keytabpath}",
      require => Exec['msktutil'],
    }
  
  }
  
  cron { 'updatekeytab':
    command  => "${msktutilpath} ${dashn} --auto-update",
    hour     => '11',
    minute   => absent,
    month    => absent,
    monthday => absent,
    special  => 'reboot',
    user     => $user,
    ensure   => $installed,
  }

}
  
