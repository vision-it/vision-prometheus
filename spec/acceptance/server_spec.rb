require 'spec_helper_acceptance'

describe 'vision_prometheus::server' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_prometheus::server': }
      FILE

      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'packages installed' do
    describe package('prometheus') do
      it { is_expected.to be_installed }
    end
  end
  context 'config provisioned' do
    describe file('/etc/default/prometheus') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'localhost' }
    end
    describe file('/etc/prometheus/prometheus.yml') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'evaluation_interval' }
      its(:content) { is_expected.to match 'Foobar' }
    end
  end
end