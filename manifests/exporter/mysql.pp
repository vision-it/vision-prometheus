# Class: vision_prometheus::exporter::mysql
# ===========================
#
# Parameters
# ----------
#
# @param password Password of Prometheus SQL user
#
# Examples
# --------
#
# @example
# contain ::vision_prometheus::exporter::mysql
#

class vision_prometheus::exporter::mysql (

  Sensitive[String] $password = Sensitive(fqdn_rand_string(32)),

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
    mode    => '0640',
    content => 'ARGS="--config.my-cnf /etc/mysql/prometheus.cnf"',
    require => Package['prometheus-mysqld-exporter'],
  }

  # SQL Config for the prometheus user
  file { '/etc/mysql/prometheus.cnf':
    ensure  => file,
    owner   => root,
    group   => prometheus,
    mode    => '0640',
    content => template('vision_prometheus/exporter/mysql.cnf.erb'),
    require => Package['prometheus-mysqld-exporter'],
  }

  # The user and grant used for the exporter
  mysql_user{ 'prometheus@localhost':
    ensure               => present,
    password_hash        => mysql::password($password.unwrap),
    max_user_connections => 2,
  }

  mysql_grant { 'prometheus@localhost/*.*':
    ensure     => present,
    user       => 'prometheus@localhost',
    table      => '*.*',
    privileges => [ 'PROCESS', 'SELECT', 'REPLICATION CLIENT' ],
    require    => Mysql_User['prometheus@localhost'],
  }
}
