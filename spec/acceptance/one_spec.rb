require 'spec_helper_acceptance'

describe 'one class' do
  describe 'without parameters' do
    it 'idempotently runs' do
      pp = <<-EOS
        class { one: }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
  describe 'as ONE HEAD' do
    it 'set up ONE HEAD' do
      pp = <<-EOS
        class { one: oned => true, node => false,}
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe user('oneadmin') do
      it { should exist }
    end
    describe package('opennebula') do
      it { should be_installed }
    end
    describe service('opennebula') do
      it { should be_enabled }
      it { should be_running }
    end

    describe package('opennebula-sunstone') do
      it { should_not be_installed }
    end

    describe service('opennebula-sunstone') do
      it { should_not be_running }
    end
  end

  describe 'as ONE Head with Sunstone' do
    it 'installs Opennebula Head with sunstone' do
      pp = <<-EOS
        class { one: oned => true, sunstone => true, node => false}
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('opennebula-sunstone') do
      it { should be_installed }
    end

    describe service('opennebula-sunstone') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(9869) do
      it { is_expected.to be_listening }
    end
  end

  describe 'as ONE Node' do
    it 'set up ONE Node' do
      pp = <<-EOS
        class { one: workernode => true }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    if fact('osfamily') == 'RedHat'
      describe package('opennebula-node-kvm') do
        it { should be_installed }
      end
    end
  end
end
