# manages mskutil keytab rotation

class msktutil::service inherits msktutil {

  if $msktutil::ensure == absent {
    file { $msktutil::keytabpath:
      ensure => absent,
    }
    $cron = $msktutil::ensure
  } else {

    $cron = $msktutil::ensurecron

    case $msktutil::usereversedns {
      true:    { $dashn = '' }
      default: { $dashn = '-N' }
    }

    exec { 'msktutil':
      command => "${msktutil::msktutilpath} ${dashn} --create --computer-name ${msktutil::myhostname} --hostname ${msktutil::myfqdn}",
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

  $msktutil::files.each | $file, $params | {
    file { $file:
      * => $params,
    }
  }

}
