require 'spec_helper_acceptance'

describe 'vision_prometheus' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_prometheus': }
      FILE

      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'packages installed' do
    describe package('prometheus') do
      it { is_expected.to be_installed }
    end
  end
  context 'test hiera data' do
    describe file('/etc/prometheus/prometheus.yml') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'Foobar' }
    end
  end
end
