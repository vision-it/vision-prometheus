require 'spec_helper_acceptance'

describe 'vision_prometheus::exporter::consul' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_prometheus::exporter::consul':
        }
      FILE

      apply_manifest(pp, catch_failures: false)
      apply_manifest(pp, catch_failures: false)
    end
  end

  context 'tarball extracted' do
    describe file('/usr/local/bin/consul_exporter') do
      it { is_expected.to exist }
    end
    describe file('/usr/local/bin/LICENSE') do
      it { is_expected.not_to exist }
    end
  end
  context 'systemd existence' do
    describe file('/etc/systemd/system/prometheus-consul-exporter.service') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
    end
  end
end
