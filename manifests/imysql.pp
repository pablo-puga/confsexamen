class confsexamen::imysql {
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
}