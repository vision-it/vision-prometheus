# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'vision_prometheus::exporter::redis' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_prometheus::exporter::redis':
        }
      FILE

      # Systemd not functional
      apply_manifest(pp, catch_failures: false)
    end
  end

  context 'tarball extracted' do
    describe file('/usr/local/bin/redis_exporter') do
      it { is_expected.to exist }
    end
    describe file('/usr/local/bin/LICENSE') do
      it { is_expected.not_to exist }
    end
  end
  context 'systemd existence' do
    describe file('/etc/systemd/system/prometheus-redis-exporter.service') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
    end
  end
end
