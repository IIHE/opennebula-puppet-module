require 'spec_helper_acceptance'

describe 'onedatastore type' do
  before :all do
    pp = <<-EOS
    class { 'one':
      oned => true,
    }
    EOS
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe 'when creating a System datastore' do

    after(:each) do
      pp = <<-EOS
      onedatastore { 'nfs_ds':
        ensure    => absent,
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    context 'with default values' do
      it 'idempotently runs' do
        pp = <<-EOS
        onedatastore { 'nfs_ds':
          tm_mad    => 'shared',
          type      => 'system_ds',
        }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end
    end

    context 'with custom values' do
      it 'idempotently runs' do
        pp = <<-EOS
        onedatastore { 'nfs_ds':
          ensure    => present,
          type      => 'system_ds',
          tm_mad    => 'shared',
          driver    => 'raw',
          disk_type => 'file',
        }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end
    end

    context 'with custom basepath' do
      it 'idempotently runs' do
        pp = <<-EOS
        onedatastore { 'nfs_ds':
          ensure    => present,
          type      => 'system_ds',
          tm_mad    => 'shared',
          driver    => 'raw',
          disk_type => 'file',
          base_path => '/tmp',
        }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end
    end
  end

  describe 'when creating a File datastore' do
    it 'work without errors' do
      pp = <<-EOS
      onedatastore { 'kernels':
        ds_mad    => 'fs',
        safe_dirs => '/var/tmp/files',
        tm_mad    => 'ssh',
        type      => 'file_ds',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
    end
  end

  describe 'when creating a Filesystem datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'production':
        ds_mad    => 'fs',
        tm_mad    => 'shared',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'when creating a VMFS datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'vmfs_ds':
        ds_mad    => 'vmfs',
        tm_mad    => 'vmfs',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'when creating a LVM datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'lvm_ds':
        ds_mad    => 'fs_lvm',
        tm_mad    => 'fs_lvm',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'when creating a Ceph datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'ceph_ds':
        ds_mad      => 'ceph',
        tm_mad      => 'ceph',
        driver      => 'raw',
        ceph_host   => 'cephhost',
        ceph_user   => 'cephuser',
        ceph_secret => 'cephsecret',
        pool_name   => 'cephpoolname',
        disk_type   => 'rbd',
        bridge_list => 'host1 host2 host3',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'when destroying a System datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'nfs_ds':
        ensure    => absent,
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'when destroying a Files datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'kernels':
        ensure    => absent,
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'when destroying a Filesystem datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'production':
        ensure    => absent,
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'when destroying a VMFS datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'vmfs_ds':
        ensure    => absent,
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'when destroying a LVM datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'lvm_ds':
        ensure    => absent,
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'when destroying a Ceph datastore' do
    it 'idempotently runs' do
      pp = <<-EOS
      onedatastore { 'ceph_ds':
        ensure    => absent,
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

end
