# Class: vision_prometheus::server
# ===========================
#
# Parameters
# ----------
#
#
# Examples
# --------
#
# @example
# contain ::vision_prometheus::server
#

class vision_prometheus::server (

  String $external_url = "${::fqdn}:9090",

) {

  contain vision_prometheus::alertmanager

  package { 'prometheus':
    ensure => present,
  }

  service { 'prometheus':
    ensure     => running,
    hasrestart => true,
    require    => Package['prometheus'],
  }

  file { '/etc/default/prometheus':
    ensure  => file,
    content => template('vision_prometheus/default.erb'),
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  file { '/etc/prometheus/prometheus.yml':
    ensure  => file,
    content => template('vision_prometheus/prometheus.yml.erb'),
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  file { '/etc/prometheus/rules.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/vision_prometheus/rules.d',
    mode    => '1755',
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }
}
