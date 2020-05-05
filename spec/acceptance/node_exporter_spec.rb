require 'spec_helper_acceptance'

describe 'vision_prometheus::exporter::node' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_prometheus::exporter::node':
        }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'packages installed' do
    describe package('prometheus-node-exporter') do
      it { is_expected.to be_installed }
    end
  end
  context 'config provisioned' do
    describe file('/etc/default/prometheus-node-exporter') do
      it { is_expected.to exist }
    end
  end
  context 'system running' do
    describe port(9100) do
      it { is_expected.to be_listening }
    end
  end
end
