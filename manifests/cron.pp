# manages msktutil keytab rotation

class msktutil::cron inherits msktutil {

  case $realcron {
    'no', false: {
      $cronensure = absent
    }
    default: {
      $cronensure = file
    }
  }
  $msktutil::cronfiles.each | $file, $item | {
    file {
      default:
        ensure  => $cronensure,
        content => template($item['template'])
      ;
      $file:
        * => $item['params']
    }
    notify { $file: }
  }
}
