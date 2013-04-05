stage { 'first': before => Stage['main'] }
class {'ssl_certificates':
    stage => 'first'
}

stage { 'setup': before => Stage['main'] }

class { '::common' : stage => 'setup' }
File <| title == '/usr/local/scripts' |>

class { '::common::developmenttools':
  stage => 'setup'
}

class { '::common::schedulingtools' : stage => 'setup' }
class { '::common::systemlibraries' : stage => 'setup' }

class { 'ntp':
  ntp_servers => ['tik.cegeka.be', 'tak.cegeka.be'],
}

include profile::repository_management

exec { 'foreman-release':
  command => 'yum -y localinstall http://yum.theforeman.org/releases/1.1/el6/x86_64/foreman-release-1.1stable-3.el6.noarch.rpm',
  path    => '/usr/bin:/usr/sbin:/bin',
}

package { ['foreman', 'foreman-cli', 'foreman-console', 'foreman-mysql']:
  ensure => present,
  require => Exec['foreman-release']
}

file { '/etc/foreman/settings.yaml':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  source  => "/vagrant/files/settings.yaml",
  require => [ Package['foreman'], Package['foreman-cli'], Package['foreman-console'], Package['foreman-mysql']]
}

file { '/etc/foreman/database.yml':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  source  => "/vagrant/files/database.yml",
  require => [ Package['foreman'], Package['foreman-cli'], Package['foreman-console'], Package['foreman-mysql']]
}

class { 'mysql::server':
  data_dir                => '/data/mysql',
  default_storage_engine  => 'InnoDB',
  innodb_buffer_pool_size => '256M'
}

mysql::database { 'foreman':
  ensure => present,
}
mysql::rights { 'foreman':
  ensure   => present,
  database => 'foreman',
  user     => 'foreman',
  password => 'foreman',
  host     => 'localhost',
}
#mysql::rights { 'foreman-localhost':
#  ensure   => present,
#  database => 'foreman',
#  user     => 'foreman',
#  password => 'foreman',
#  host     => 'localhost',
#}

exec { 'dbmigrate':
  command => 'su - foreman -s /bin/bash -c /usr/share/foreman/extras/dbmigrate',
  path    => '/usr/bin:/usr/sbin:/bin',
  require => [ Mysql::Database['foreman'], Mysql::Rights['foreman'], File['/etc/foreman/settings.yaml'], File['/etc/foreman/database.yml'] ]
}

service { 'foreman':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
  require    => Exec['dbmigrate']
}

