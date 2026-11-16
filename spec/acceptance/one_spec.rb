require 'spec_helper_acceptance'

describe 'one class' do
  context 'with an OpenNebula 7.4 frontend' do
    let(:manifest) do
      <<~MANIFEST
        class { 'one':
          oned        => true,
          workernode  => false,
          sunstone    => true,
          backend     => 'sqlite',
          one_version => '7.4',
        }
      MANIFEST
    end

    it 'installs and configures the frontend idempotently' do
      apply_manifest(manifest, catch_failures: true)
      apply_manifest(manifest, catch_changes: true)
    end

    it 'installs the expected OpenNebula packages' do
      expect(run_shell('rpm -q opennebula').exit_code).to eq(0)
      expect(run_shell('rpm -q opennebula-fireedge').exit_code).to eq(0)
      expect(run_shell('rpm -q opennebula-guacd').exit_code).to eq(0)
    end

    it 'does not install the legacy Sunstone package' do
      result = run_shell('rpm -q opennebula-sunstone', expect_failures: true)
      expect(result.exit_code).not_to eq(0)
    end

    it 'runs the OpenNebula and FireEdge services' do
      expect(run_shell('systemctl is-active opennebula').stdout.strip).to eq('active')
      expect(run_shell('systemctl is-active opennebula-fireedge').stdout.strip).to eq('active')
    end

    it 'writes the expected configuration files' do
      expect(run_shell('test -f /etc/one/oned.conf').exit_code).to eq(0)
      expect(run_shell('test -f /etc/one/fireedge-server.conf').exit_code).to eq(0)
    end
  end
end
