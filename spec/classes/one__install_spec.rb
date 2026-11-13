require 'spec_helper'

describe 'one::install', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }

      context 'general' do
        let(:params) do
          {
            dbus_pkg: 'dbus',
            package_ensure: 'latest',
            http_proxy: :undef,
          }
        end

        it { is_expected.to contain_class('one::install') }
        it { is_expected.to contain_package('dbus').with_ensure('latest') }
      end

      context 'with gemrc and proxy not set' do
        let(:params) do
          {
            dbus_pkg: 'dbus',
            package_ensure: 'latest',
            http_proxy: :undef,
          }
        end
        no_proxy = %Q{---\nhttp_proxy: \n}

        it { is_expected.to contain_file('/etc/gemrc').with_content(no_proxy) }
      end

      context 'with gemrc and proxy set' do
        let(:params) do
          {
            http_proxy: 'http://some.crap.com:8080',
            dbus_pkg: 'dbus',
            package_ensure: 'latest',
          }
        end
        proxy = %Q{---\nhttp_proxy: http://some.crap.com:8080\n}

        it { is_expected.to contain_file('/etc/gemrc').with_content(proxy) }
      end
    end
  end
end
