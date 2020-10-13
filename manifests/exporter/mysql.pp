# Class: vision_prometheus::exporter::mysql
# ===========================
#
# Parameters
# ----------
#
# @param _password Password of Prometheus SQL user
#
# Examples
# --------
#
# @example
# contain ::vision_prometheus::exporter::mysql
#

class vision_prometheus::exporter::mysql (

  Sensitive[String] $password,

) {

  package { 'prometheus-mysqld-exporter':
    ensure => present,
  }

  service { 'prometheus-mysqld-exporter':
    ensure     => running,
    hasrestart => true,
    require    => Package['prometheus-mysqld-exporter'],
  }

  file { '/etc/default/prometheus-mysqld-exporter':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => 'ARGS="--config.my-cnf /etc/mysql/prometheus.cnf"',
    require => Package['prometheus-mysqld-exporter'],
  }

  file { '/etc/mysql/prometheus.cnf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('vision_prometheus/exporter/mysql.cnf.erb'),
    require => Package['prometheus-mysqld-exporter'],
  }

  mysql_user{ 'prometheus@localhost':
    ensure               => present,
    password_hash        => mysql::password($password.unwrap),
    max_user_connections => 2,
    plugin               => 'mysql_native_password',
  }

  mysql_grant { 'prometheus@localhost/*.*':
    ensure     => present,
    user       => 'prometheus@localhost',
    table      => '*.*',
    privileges => [ 'PROCESS', 'SELECT', 'REPLICATION CLIENT' ],
    require    => Mysql_User['prometheus@localhost'],
  }
}
