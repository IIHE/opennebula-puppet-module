require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::compute_node::install', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      let(:params) { {
        node_packages: 'bogus_package'
      } }
      it { is_expected.to contain_class('one::compute_node::install') }
      it { is_expected.to contain_package('bogus_package').with_ensure('latest') }
    end
  end
end
