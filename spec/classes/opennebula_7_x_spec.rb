require 'spec_helper'

describe 'one', type: :class do
  versions = {
    '7.0.2' => { minor: '7.0', oneform: false, log_result_length: false },
    '7.2.1' => { minor: '7.2', oneform: true, log_result_length: false },
    '7.4.2' => { minor: '7.4', oneform: true, log_result_length: true },
  }

  on_supported_os.each do |os, os_facts|
    versions.each do |one_version, expectations|
      context "On #{os} with OpenNebula #{one_version}" do
        let(:facts) { os_facts }
        let(:params) do
          {
            oned: true,
            sunstone: true,
            workernode: false,
            one_version: one_version,
          }
        end

        it { is_expected.to contain_class('one::oned') }
        it { is_expected.to contain_class('one::oned::sunstone') }
        it { is_expected.to contain_class('one::oned::sunstone::install') }
        it { is_expected.to contain_class('one::oned::sunstone::config') }
        it { is_expected.to contain_class('one::oned::sunstone::service') }

        it { is_expected.to contain_package('opennebula-fireedge') }
        it { is_expected.to contain_package('opennebula-guacd') }
        it { is_expected.not_to contain_package('opennebula-sunstone') }

        it { is_expected.to contain_file('/etc/one/fireedge-server.conf').with_ensure('file') }
        it { is_expected.to contain_service('opennebula-fireedge').with_ensure('running') }
        it { is_expected.not_to contain_service('opennebula-sunstone') }

        it do
          is_expected.to contain_yumrepo('opennebula')
            .with_baseurl(%r{/#{Regexp.escape(expectations[:minor])}/RedHat/})
        end

        if expectations[:oneform]
          it { is_expected.to contain_file('/etc/one/fireedge-server.conf').with_content(/oneform_server/) }
        else
          it { is_expected.not_to contain_file('/etc/one/fireedge-server.conf').with_content(/oneform_server/) }
        end

        if expectations[:log_result_length]
          it { is_expected.to contain_file('/etc/one/oned.conf').with_content(/LOG_RESULT_LENGTH/) }
        else
          it { is_expected.not_to contain_file('/etc/one/oned.conf').with_content(/LOG_RESULT_LENGTH/) }
        end
      end
    end
  end
end
