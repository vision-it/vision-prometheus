# Class: vision_prometheus::exporter::consul
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_prometheus::exporter::consul
#

class vision_prometheus::exporter::consul (

  String $archive_source,
  String $archive_checksum,

) {

  archive { '/tmp/consul-exporter.tar.gz' :
    ensure          => present,
    source          => $archive_source,
    checksum        => $archive_checksum,
    checksum_type   => 'sha256',
    extract         => true,
    extract_command => 'tar xfz %s --wildcards --strip-components=1 "*/consul_exporter"',
    extract_path    => '/usr/local/bin',
    creates         => '/usr/local/bin/consul_exporter',
}

  file { '/etc/systemd/system/prometheus-consul-exporter.service':
    ensure  => present,
    content => template('vision_prometheus/exporter/prometheus-consul-exporter.service'),
  }

  service { 'prometheus-consul-exporter.service':
    ensure   => running,
    enable   => true,
    provider => 'systemd',
    require  => File['/etc/systemd/system/prometheus-consul-exporter.service'],
  }
}
