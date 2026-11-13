require 'spec_helper'

describe 'one', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let(:oned_config) { '/etc/one/oned.conf' }

      context 'as ONE 6.6 with default monitoring intervals' do
        let(:params) do
          {
            oned: true,
            one_version: '6.6',
            sunstone: true,
            workernode: false,
          }
        end

        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_DATASTORE = 300/m) }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_MARKET    = 600/m) }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/admin.yaml').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/cloud.yaml').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/user.yaml').with_ensure('file') }
      end

      context 'as ONE 6.6 with custom monitoring intervals' do
        let(:params) do
          {
            oned: true,
            one_version: '6.6',
            workernode: false,
            oned_monitoring_interval_datastore: 400,
            oned_monitoring_interval_market: 800,
          }
        end

        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_DATASTORE = 400/m) }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_MARKET    = 800/m) }
      end

      context 'with an unsupported OpenNebula version' do
        let(:params) { { oned: true, one_version: '5.8', workernode: false, sunstone_fireedge: false } }

        it do
          is_expected.to compile.and_raise_error(/One_version 5\.8 not supported/)
        end
      end
    end
  end
end
