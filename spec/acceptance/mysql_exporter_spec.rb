# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'vision_prometheus::exporter::mysql' do
  context 'with defaults' do
    it 'run idempotently' do
      setup = <<-FILE
        # Manually start with init, since we aint got no systemd
        package { 'mariadb-server':
          ensure => present,
        }->
          exec { '/bin/cp -p /etc/init.d/mysql /etc/init.d/mariadb':
        }->
          exec { '/bin/bash /etc/init.d/mysql start':
        }
      FILE
      apply_manifest(setup, catch_failures: true)

      pp = <<-FILE
        class { '::mysql::server':
           package_name  => 'mariadb-server',
        }

        class { 'vision_prometheus::exporter::mysql':
        }
      FILE

      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'packages installed' do
    describe package('prometheus-mysqld-exporter') do
      it { is_expected.to be_installed }
    end
  end
  context 'config provisioned' do
    describe file('/etc/default/prometheus-mysqld-exporter') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'ARG' }
    end
    describe file('/etc/mysql/prometheus.cnf') do
      it { is_expected.to exist }
      it { is_expected.to be_grouped_into 'prometheus' }
      its(:content) { is_expected.to match 'Puppet' }
    end
  end

  context 'system running' do
    describe command('mysql -e "select user from mysql.user"') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to contain 'prometheus' }
    end
  end
end
