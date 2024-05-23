require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::oned::sunstone::install', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let (:hiera_config) { hiera_config }
      let (:params) { { oned_sunstone_packages: 'bogus-package' } }
      context 'general' do
        it { should contain_class('one::oned::sunstone::install') }
        it { should contain_package('bogus-package').with_ensure('latest') }
      end
    end
  end
end
