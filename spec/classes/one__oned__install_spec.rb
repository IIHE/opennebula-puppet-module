require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::oned::install', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let (:hiera_config) { hiera_config }
      let (:pre_condition) { 'include one' }
      context 'general' do
        it { is_expected.to contain_package('sinatra').with_provider('gem') }
        it { is_expected.to contain_package('builder').with_provider('gem') }
        if os_facts[:osfamily] == 'Debian'
          it { is_expected.to contain_package('parse-cron').with_provider('gem') }
        end
      end
      if os_facts[:osfamily] == 'RedHat'
        context 'with rpm instead of gems' do
          let (:params) { { use_gems: false } }
          it { is_expected.to contain_package('rubygem-sinatra') }
          it { is_expected.to contain_package('rubygem-builder') }
          it { is_expected.not_to contain_package('sinatra').with_provider('gem') }
          it { is_expected.not_to contain_package('builder').with_provider('gem') }
        end
      end
    end
  end
end
