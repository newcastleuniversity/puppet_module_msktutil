# manages msktutil keytab rotation

class msktutil::cron inherits msktutil {

  case $msktutil::realcron {
    'no', false: {
      $ensure = absent
    }
    default: {
      $ensure = file
    }
  }
  $msktutil::cronfiles.each | $file, $item | {
    file {
      default:
        ensure  => $ensure,
        content => template($item['template'])
      ;
      $file:
        * => $item['params']
    }
  }
}
