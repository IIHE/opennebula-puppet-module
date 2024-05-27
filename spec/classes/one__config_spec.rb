require 'spec_helper'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'one::config', type: :class do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts }
      context 'general' do
        let(:params) { {} }
        it { is_expected.to contain_file('/var/lib/one') \
          .with_ensure('directory') \
          .with_owner('oneadmin') \
          .with_group('oneadmin')
        }
      end
    end
  end
end
