class msktutil::service inherits msktutil {

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
  
