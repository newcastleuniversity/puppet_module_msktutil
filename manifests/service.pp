class msktutil::service (
  $msktutilpath  = $msktutil::parammsktutilpath,
  $packagename   = $msktutil::param::packagename,
  $usereversedns = $msktutil::param::usereversedns,
  $user          = $msktutil::param::user,
  $group         = $msktutil::param::group,
  $chmodpath     = $msktutil::param::chmodpath,
  $keytabmode    = $msktutil::param::keytabmode,
  $keytabpath    = $msktutil::param::keytabpath,
  $installed     = $msktutil::param::installed,
  $updatehour    = $msktutil::param::updatehour,
) inherits msktutil {

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
    hour     => $updatehour,
    minute   => absent,
    month    => absent,
    monthday => absent,
    special  => absent,
    user     => $user,
    ensure   => $installed,
  }

}
  
