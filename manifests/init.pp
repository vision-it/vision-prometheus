# Class: vision_prometheus
# ===========================
#
# Parameters
# ----------
#
# @param global_config Global Prometheus config as Hash
# @param scrape_configs Scrape Configs Hashes in an Array
#
# Examples
# --------
#
# @example
# contain ::vision_prometheus
#

class vision_prometheus (

  String $external_url,
  Hash $global_config,
  Array $scrape_configs,

) {

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

}
