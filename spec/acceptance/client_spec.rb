require 'spec_helper_acceptance'

describe 'vision_prometheus::client' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_prometheus::client':
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
end
