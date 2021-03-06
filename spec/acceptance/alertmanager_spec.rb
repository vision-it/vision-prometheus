# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'vision_prometheus::alertmanager' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_prometheus::alertmanager': }
      FILE

      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'packages installed' do
    describe package('prometheus-alertmanager') do
      it { is_expected.to be_installed }
    end
  end
  context 'config provisioned' do
    describe file('/etc/prometheus/alertmanager.yml') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'localhost' }
      its(:content) { is_expected.to match 'foobar.org' }
      its(:content) { is_expected.to match 'sender.org' }
    end
  end
  describe command('/usr/bin/amtool check-config /etc/prometheus/alertmanager.yml') do
    its(:exit_status) { is_expected.to eq 0 }
  end
end
