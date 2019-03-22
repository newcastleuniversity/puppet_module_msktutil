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
      command => "${msktutil::msktutilpath} ${dashn} --create --computer-name ${msktutil::myhostname}",
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

  file { 'msktutil-cronstub':
    ensure  => file,
    mode    => '0755',
    owner   => $msktutil::user,
    path    => $msktutil::cronstub,
    content => "#!/bin/sh\n${msktutil::msktutilpath} ${dashn} --auto-update --auto-update-interval ${msktutil::keytabreplace} --computer-name ${msktutil::myhostname}", # lint:ignore:140chars
  }

}
