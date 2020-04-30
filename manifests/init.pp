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

  file { '/etc/prometheus/prometheus.yml':
    ensure       => file,
    content      => template('vision_prometheus/prometheus.yml.erb'),
    require      => Package['prometheus'],
    notify       => Service['prometheus'],
    validate_cmd => '/usr/bin/promtool check config %',
  }

}
