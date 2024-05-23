require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::oned::install', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let (:hiera_config) { hiera_config }
      let (:pre_condition) { 'include one' }
      context 'general' do
        it { should contain_package('sinatra').with_provider('gem') }
        it { should contain_package('builder').with_provider('gem') }
        if os_facts[:osfamily] == 'Debian'
          it { should contain_package('parse-cron').with_provider('gem') }
        end
      end
      if os_facts[:osfamily] == 'RedHat'
        context 'with rpm instead of gems' do
          let (:params) { { use_gems: false } }
          it { should contain_package('rubygem-sinatra') }
          it { should contain_package('rubygem-builder') }
          it { should_not contain_package('sinatra').with_provider('gem') }
          it { should_not contain_package('builder').with_provider('gem') }
        end
      end
    end
  end
end
