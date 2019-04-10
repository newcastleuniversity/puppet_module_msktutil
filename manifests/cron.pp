# manages msktutil keytab rotation

class msktutil::cron inherits msktutil {

  $msktutil::cronfiles.each | $file, $item | {
    file {
      default:
        ensure  => $msktutil::realcron,
        content => template($item['template'])
      ;
      $file:
        * => $item['params']
    }
  }

}
