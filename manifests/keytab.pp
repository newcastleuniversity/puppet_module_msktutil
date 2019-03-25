class msktutil::keytab inherits msktutil {

  case $realmakekeytab {
    'true', 'yes', true: {
      exec { 'msktutil':
        command => "${msktutil::msktutilpath} --create ${dashn} --computer-name ${facts['hostname']} --hostname ${facts['fqdn']} ${msktutil::otherropts}",
        creates => $msktutil::keytabpath,
        user    => $msktutil::user,
        group   => $msktutil::group,
        mode    => $msktutil::keytabmode,
      }
    }
    default: {}
  }


}
