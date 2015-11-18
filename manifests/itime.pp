class confs::itime {
  class { 'timezone':
    timezone => 'Europe/Madrid',
  }

  class { '::ntp':
    server => [ '1.es.pool.ntp.org', '2.europe.pool.ntp.org', '3.europe.pool.ntp.org' ],
  }
}