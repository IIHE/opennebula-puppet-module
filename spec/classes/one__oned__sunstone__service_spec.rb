require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::oned::sunstone::service', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let (:hiera_config) { hiera_config }
      context 'general' do
        it { should contain_class('one::oned::sunstone::service') }
      end
      context 'with passenger disabled' do
        it { should contain_service('opennebula-sunstone') \
        .with_ensure('running') \
        .with_enable('true') \
        .with_require('Service[opennebula]')
        }
      end
      context 'with passenger enabled' do
        let (:params) { {sunstone_passenger: true} }
        it { should contain_service('opennebula-sunstone') \
        .with_ensure('stopped') \
        .with_enable('false') \
        .with_require('Service[opennebula]')
        }
      end
    end
  end
end
