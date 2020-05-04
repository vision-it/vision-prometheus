# Class: vision_prometheus::exporter::mysql
# ===========================
#
# Parameters
# ----------
#
# @param mysql_password Password of Prometheus SQL user
#
# Examples
# --------
#
# @example
# contain ::vision_prometheus::exporter::mysql
#

class vision_prometheus::exporter::mysql (

  String $mysql_password,

) {

  package { 'prometheus-mysqld-exporter':
    ensure => present,
    notify => Exec['prometheus_user'],
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

  exec { 'prometheus_user':
    command     => "/usr/bin/mysql --defaults-file='/root/.my.cnf' -e \" CREATE USER IF NOT EXISTS 'prometheus'@'localhost' IDENTIFIED BY '${mysql_password}' WITH MAX_USER_CONNECTIONS 2;\"",
    refreshonly => true,
  }

  mysql_grant { 'prometheus@localhost/*.*':
    ensure     => present,
    user       => 'prometheus@localhost',
    table      => '*.*',
    privileges => [ 'PROCESS', 'SELECT', 'REPLICATION CLIENT' ],
    require    => Exec['prometheus_user'],
  }
}
