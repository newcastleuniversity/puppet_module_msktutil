# manages msktutil keytab rotation

class msktutil::cron inherits msktutil {

  $msktutil::cronfiles.each | $file, $item | {
    file {
      default:
        ensure  => $realcron,
        content => template($item['template'])
      ;
      $file:
        * => $item['params']
    }
    notify { $file: }
  }

}
