class confsexamen::ifirewall {
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