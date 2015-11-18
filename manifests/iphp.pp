class confsexamen::iphp {
  include ::yum::repo::remi
  package { 'libzip-last':
    require => Yumrepo['remi']
  }

  class{ '::yum::repo::remi_php56':
    require => Package['libzip-last']
  }

  class { 'php':
    version => 'latest',
    require => Yumrepo['remi-php56'],
  }
  
  class { '::apache::mod::php':
	content => "
AddHandler php5-script .php
AddType text/html .php\n",
  }
}