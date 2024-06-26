require 'spec_helper_acceptance'

describe 'onevnet type' do
  before :all do
    pp = <<-EOS
      class { 'one':
        oned => true,
      }
    EOS
    apply_manifest(pp, catch_failures: true)
  end

  describe 'when creating vnet' do
    it 'idempotently runs' do
      pp = <<-EOS
      onevnet { 'vnet1':
          ensure          => present,
          bridge          => 'basebr0',
          phydev          => 'br0',
          dnsservers      => ['8.8.8.8', '4.4.4.4'],
          gateway         => '10.0.2.1',
          vlanid          => '1550',
          netmask         => '255.255.0.0',
          network_address => '10.0.2.0',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
    end
  end

  describe 'when creating vnet and addressrange' do
    it 'idempotently runs' do
      pp = <<-EOS
      onevnet { 'vnet2':
          ensure          => present,
          bridge          => 'basebr0',
          phydev          => 'br0',
          dnsservers      => ['8.8.8.8', '4.4.4.4'],
          gateway         => '10.0.2.1',
          vlanid          => '1550',
          netmask         => '255.255.0.0',
          network_address => '10.0.2.0',
      }

      onevnet_addressrange { 'ar2':
          ensure        => present,
          onevnet_name  => 'vnet2',
          protocol      => ip4,
          ip_size       => '10',
          mac           => '02:00:0a:00:00:96',
          ip_start      => '10.0.2.20'
      }
      EOS

      apply_manifest(pp, catch_failures: true)
    end
  end

  describe 'when creating an IPv6 Network' do
    it 'idempotently runs' do
      pp = <<-EOS
      onevnet { 'vnet3':
          ensure          => present,
          bridge          => 'basebr0',
          phydev          => 'br0',
          dnsservers      => ['8.8.8.8', '4.4.4.4'],
          gateway         => '10.0.2.1',
          vlanid          => '1550',
          netmask         => '255.255.0.0',
          network_address => '10.0.2.0',
      }

      onevnet_addressrange { 'ar3':
          ensure        => present,
          onevnet_name  => 'vnet3',
          protocol      => ip6,
          ip_size       => '10',
          mac           => '02:00:0a:00:00:96',
          ip_start      => '10.0.2.20'
      }
      EOS

      apply_manifest(pp, catch_failures: true)
    end
  end

  describe 'when creating a vnet with context variables' do
    it 'idempotently runs' do
      pp = <<-eos
      onevnet { 'vnet4':
          ensure          => present,
          bridge          => 'basebr0',
          phydev          => 'br0',
          dnsservers      => ['8.8.8.8', '4.4.4.4'],
          gateway         => '10.0.2.1',
          vlanid          => '1550',
          netmask         => '255.255.0.0',
          network_address => '10.0.2.0',
          context         => {
              security_groups    => '0',
              search_domain      => 'my.domain',
              filter_ip_spoofing => 'yes',
          },
      }
      eos

      apply_manifest(pp, catch_failures: true)
    end
  end

  describe 'when updating a vnet with context variables' do
    it 'idempotently runs' do
      pp = <<-eos
      onevnet { 'vnet4':
          ensure          => present,
          bridge          => 'basebr0',
          phydev          => 'br0',
          dnsservers      => ['8.8.8.8', '4.4.4.4'],
          gateway         => '10.0.2.1',
          vlanid          => '1550',
          netmask         => '255.255.0.0',
          network_address => '10.0.2.0',
          context         => {
              security_groups     => '0',
              search_domain       => 'my.domain',
              filter_ip_spoofing  => 'yes',
              filter_mac_spoofing => 'yes',
          },
      }
      eos

      apply_manifest(pp, catch_failures: true)
    end
  end

  describe 'when updating a fixed vnet' do
    it 'idempotently runs' do
      pp = <<-EOS
      onevnet { 'vnet1':
          ensure          => present,
          bridge          => 'basebr0',
          phydev          => 'br0',
          dnsservers      => ['8.8.8.8', '4.4.4.4'],
          gateway         => '10.0.2.1',
          vlanid          => '1550',
          netmask         => '255.255.0.0',
          network_address => '10.0.2.10',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
    end
  end

  describe 'when deleting a Network' do
    it 'idempotently runs' do
      pp = <<-EOS
        onevnet { 'vnet':
          ensure => absent,
        }
        onevnet { 'vnet2':
          ensure => absent,
        }
        onevnet { 'vnet3':
          ensure => absent,
        }
        onevnet { 'vnet4':
          ensure => absent,
        }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
