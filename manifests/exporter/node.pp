# Class: vision_prometheus::exporter::node
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_prometheus::exporter::node
#

class vision_prometheus::exporter::node {

  package { 'prometheus-node-exporter':
    ensure => present,
  }

  service { 'prometheus-node-exporter':
    ensure     => running,
    hasrestart => true,
    require    => Package['prometheus-node-exporter'],
  }

}
