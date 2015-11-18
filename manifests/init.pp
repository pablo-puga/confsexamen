# Class: confsexamen
# ===========================
#
# Full description of class confsexamen here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'confsexamen':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class confsexamen {

  class{ 'apache': }

  apache::vhost { 'myMpwar.prod':
    port    => '80',
    docroot       => '/var/www/myproject',
  }

  apache::vhost { 'myMpwar.dev':
    port    => '80',
    docroot       => '/var/www/myproject',
  }
  
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
  
  include ::yum::repo::mysql_community
  
  class { 'mysql': 
	require => Yumrepo["mysql56-community"],
  }
	
  mysql::grant { 'mpwar_test':
	mysql_user      => 'mpwar',
	mysql_password  => 'mpwardb',
	require         => Package['mysql']
  }	
  
  mysql::grant { 'mympwar':
	mysql_user      => 'mpwar',
	mysql_password  => 'mpwardb',
	require         => Package['mysql']
  }
  
  class { 'timezone':
    timezone => 'Europe/Madrid',
  }

  class { '::ntp':
    server => [ '1.es.pool.ntp.org', '2.europe.pool.ntp.org', '3.europe.pool.ntp.org' ],
  }
  
  include '::mongodb::server'
  
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
  
  if $operatingsystemrelease == '7.0.1406' {
    # firewalld - Centos 7
    firewalld_rich_rule { 'Accept HTTP':
      ensure  => present,
      zone    => 'public',
      service => 'http',
      action  => 'accept',
    }
  } else {
    package { 'iptables':
      ensure => present,
      before => File['/etc/sysconfig/iptables'],
    }
    file { '/etc/sysconfig/iptables':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => 600,
      replace => true,
      source  => "puppet:///modules/confsexamen/iptables.txt",
    }
    service { 'iptables':
      ensure     => running,
      enable     => true,
      subscribe  => File['/etc/sysconfig/iptables'],
    }
  }

}
