# Creates the keytab.
class msktutil::keytab inherits msktutil {
  case $msktutil::realmakekeytab {
    'yes', true: {
      exec { 'msktutil':
        command => "${msktutil::msktutilpath} \
          --create ${msktutil::dashn} \
          --computer-name ${facts['networking']['hostname']} \
          --hostname ${facts['networking']['fqdn']} \
          ${msktutil::extraopts}",
        creates => $msktutil::keytabpath,
        user    => 'root',
        group   => $msktutil::group,
      }
      exec { 'chmod':
        command => "${msktutil::chmodpath} ${msktutil::keytabmode} ${msktutil::keytabpath}",
        require => Exec['msktutil'],
      }
    }
    default: {}
  }
}
