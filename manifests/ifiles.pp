class confsexamen::ifiles {
  file { '/var/www/myproject/info.php':
    ensure  => present,
    owner   => "apache",
    group   => "apache",
	mode	=> '0644',
    replace => true,
    content => "<?php phpinfo();?>\n",
  }

  file { '/var/www/myproject/index.php':
    ensure  => present,
    owner   => "apache",
    group   => "apache",
	mode	=> '0644',
    replace => true,
    content => "Hello World. Sistema operativo $operatingsystem $operatingsystemrelease\n",
  }
}