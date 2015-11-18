class confsexamen::iapache {
  class{ 'apache': }

  apache::vhost { 'myMpwar.prod':
    port    => '80',
    docroot       => '/var/www/myproject',
  }

  apache::vhost { 'myMpwar.dev':
    port    => '80',
    docroot       => '/var/www/myproject',
  }
}