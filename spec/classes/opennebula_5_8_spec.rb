require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one', type: :class do
  let(:hiera_config) { hiera_config }
  require 'spec_helper'

  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      hiera = Hiera.new(config: hiera_config)
      configdir = '/etc/one'
      oned_config = "#{configdir}/oned.conf"
      context 'as oned-5.8 with default params' do
        let(:params) { {
          oned: true,
          one_version: '5.8',
          sunstone: true,
          workernode: false,
        } }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_HOST\s+= 180/m) }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_VM\s+= 180/m) }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_DATASTORE\s+= 300/m) }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_MARKET\s+= 600/m) }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/admin.yaml').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/cloud.yaml').with_ensure('file') }
        it { is_expected.to contain_file('/etc/one/sunstone-views/mixed/user.yaml').with_ensure('file') }
      end
      context 'as oned-5.8 with custom params' do
        let(:params) { {
          oned: true,
          one_version: '5.8',
          workernode: false,
          oned_monitoring_interval_host: '200',
          oned_monitoring_interval_vm: '200',
          oned_monitoring_interval_datastore: '400',
          oned_monitoring_interval_market: '800',
        } }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_HOST\s+= 200/m) }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_VM\s+= 200/m) }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_DATASTORE\s+= 400/m) }
        it { is_expected.to contain_file(oned_config).with_content(/^MONITORING_INTERVAL_MARKET\s+= 800/m) }
      end
    end
  end
end
