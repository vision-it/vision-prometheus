# Class: vision_prometheus::alertmanager
# ===========================
#
# Parameters
# ----------
#
# @param smtp_smarthost The smarthost and SMTP sender used for mail notifications
# @param smtp_receiver The notification receivers
#
# Examples
# --------
#
# @example
# contain ::vision_prometheus::alertmanager
#

class vision_prometheus::alertmanager (

  String $smtp_smarthost,
  String $smtp_receiver,

) {

  package { 'prometheus-alertmanager':
    ensure => present,
  }

  service { 'prometheus-alertmanager':
    ensure     => running,
    hasrestart => true,
    require    => Package['prometheus-alertmanager'],
  }

  file { '/etc/prometheus/alertmanager.yml':
    ensure  => file,
    content => template('vision_prometheus/alertmanager.yml.erb'),
    require => Package['prometheus-alertmanager'],
    notify  => Service['prometheus-alertmanager'],
  }

}
