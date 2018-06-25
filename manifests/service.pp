# manages mskutil keytab rotation

class msktutil::service inherits msktutil {

  if $msktutil::ensure == absent {
    file { $msktutil::keytabpath:
      ensure => absent,
    }
    $cron = $msktutil::ensure
  } else {

    $cron = $msktutil::ensurecrontab

    case $msktutil::usereversedns {
      true:    { $dashn = '' }
      default: { $dashn = '-N' }
    }

    exec { 'msktutil':
      command => "${msktutil::msktutilpath} ${msktutil::dashn} --create --computer-name ${msktutil::myhostname}",
      creates => $msktutil::keytabpath,
      user    => $msktutil::user,
      group   => $msktutil::group,
      notify  => Exec['keytabperms'],
    }

    exec { 'keytabperms':
      command => "${msktutil::chmodpath} ${msktutil::keytabmode} ${msktutil::keytabpath}",
      require => Exec['msktutil'],
    }

  }

  cron { 'updatekeytab':
    ensure   => $cron,
    command  => "${msktutil::msktutilpath} ${dashn} --auto-update",
    hour     => $msktutil::updatehour,
    minute   => absent,
    month    => absent,
    monthday => absent,
    special  => absent,
    user     => $msktutil::user,
  }

}

