# OpenNebula Puppet provider for onevnet
#
# License: APLv2
#
# Authors:
# Based upon initial work from Ken Barber
# Modified by Martin Alfke
#
# Copyright
# initial provider had no copyright
# Deutsche Post E-POST Development GmbH - 2014, 2015
#

require 'rubygems'
require 'nokogiri' if Puppet.features.nokogiri?

Puppet::Type.type(:onevnet).provide(:cli) do
  confine feature: :nokogiri
  desc 'onevnet provider'

  has_command(:onevnet, 'onevnet') do
    environment HOME: '/root', ONE_AUTH: '/var/lib/one/.one/one_auth'
  end

  mk_resource_methods

  # Create a network with onevnet by passing in a temporary template.
  def create
    file = Tempfile.new("onevnet-#{resource[:name]}")
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.VNET do
        xml.NAME resource[:name]
        xml.VN_MAD resource[:vn_mad] if resource[:vn_mad]
        xml.BRIDGE resource[:bridge]
        xml.PHYDEV resource[:phydev] if resource[:phydev]
        xml.VLAN_ID resource[:vlanid] if resource[:vlanid]
        xml.DNS resource[:dnsservers].join(' ') if resource[:dnsservers]
        xml.GATEWAY resource[:gateway] if resource[:gateway]
        xml.NETWORK_MASK resource[:netmask] if resource[:netmask]
        xml.NETWORK_ADDRESS resource[:network_address] if resource[:network_address]
        xml.MTU resource[:mtu] if resource[:mtu]
        xml.CONTEXT resource[:context].each { |k, v| xml.send(k.upcase, v) } if resource[:context]
      end
    end
    tempfile = builder.to_xml
    file.write(tempfile)
    file.close
    self.debug "Adding new network using template: #{tempfile}"
    onevnet('create', file.path)
    file.delete
    @property_hash[:ensure] = :present
  end

  # Destroy a network using onevnet delete
  def destroy
    onevnet('delete', resource[:name])
    @property_hash.clear
  end

  # Check if a network exists by scanning the onevnet list
  def exists?
    @property_hash[:ensure] == :present
  end

  # Return the full hash of all existing onevnet resources
  def self.instances
    parameter_names = ['NAME', 'VN_MAD', 'BRIDGE', 'PHYDEV', 'VLAN_ID', 'DNS', 'GATEWAY', 'NETWORK_MASK', 'NETWORK_ADDRESS', 'MTU', 'TEXT']
    vnets = Nokogiri::XML(onevnet('list', '-x')).root.xpath('/VNET_POOL/VNET')
    vnets.collect do |vnet|
      new(
          ensure:           :present,
          name:             vnet.xpath('./NAME').text,
          vn_mad:           (vnet.xpath('./VN_MAD').text unless vnet.xpath('./VN_MAD').nil?),
          bridge:           vnet.xpath('./BRIDGE').text,
          phydev:           vnet.xpath('./PHYDEV').text,
          vlanid:           vnet.xpath('./VLAN_ID').text,
          context:          (Hash[ vnet.xpath('./TEMPLATE').children.collect { |c|
                                  [c.name.downcase, c.text] unless parameter_names.include?(c.name.upcase)
                                }.reject { |c| c.nil? } ] unless vnet.xpath('./TEMPLATE').nil?),
          dnsservers:       (vnet.xpath('./TEMPLATE/DNS').text.split(' ') unless vnet.xpath('./TEMPLATE/DNS').nil?),
          gateway:          (vnet.xpath('./TEMPLATE/GATEWAY').text unless vnet.xpath('./TEMPLATE/GATEWAY').nil?),
          netmask:          (vnet.xpath('./TEMPLATE/NETWORK_MASK').text unless vnet.xpath('./TEMPLATE/NETWORK_MASK').nil?),
          network_address:  (vnet.xpath('./TEMPLATE/NETWORK_ADDRESS').text unless vnet.xpath('./TEMPLATE/NETWORK_ADDRESS').nil?),
          mtu:              (vnet.xpath('./TEMPLATE/MTU').text unless vnet.xpath('./TEMPLATE/MTU').nil?),
      )
    end
  end

  def self.prefetch(resources)
    vnets = instances
    resources.keys.each do |name|
      provider = vnets.find { |vnet| vnet.name == name }
      resources[name].provider = provider unless provider.nil?
    end
  end

  def flush
    file = Tempfile.new('onevnet')
    file << @property_hash.map { |k, v|
      unless resource[k].nil? or resource[k].to_s.empty? or [:name, :provider, :ensure].include?(k)
        case k
          when :vlanid
            ['VLAN_ID', v]
          when :addressrange
            k.each_pair { |key, value| }
          when :dnsservers
            ['DNS', "\"#{v.join(' ')}\""]
          when :netmask
            ['NETWORK_MASK', v]
          when :context
            # do nothing here, see below
          else
            [k.to_s.upcase, v]
        end
      end
    }.map { |a| "#{a[0]} = #{a[1]}" unless a.nil? }.join("\n")
    unless @property_hash[:context].nil? or @property_hash[:context].to_s.empty?
      file << "\n"
      file << @property_hash[:context].map { |k, v|
        [k.to_s.upcase, v]
      }.map { |a| "#{a[0]} = #{a[1]}" unless a.nil? }.join("\n")
    end
    file.close
    self.debug(IO.read file.path)
    onevnet('update', resource[:name], file.path, '--append') unless @property_hash.empty?
    file.delete
  end
end
