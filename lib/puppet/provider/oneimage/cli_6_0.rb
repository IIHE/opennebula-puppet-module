# OpenNebula Puppet provider for oneimage
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

Puppet::Type.type(:oneimage).provide(:cli_6_0) do
  confine feature: :nokogiri
  confine true: begin
    if File.exists?('/var/lib/one/remotes/VERSION')
      file = File.open('/var/lib/one/remotes/VERSION', 'r')
      one_version = file.read
      file.close
      Gem::Version.new(one_version) > Gem::Version.new('6.0')
    end
  end
  desc 'oneimage provider for opennebula 6.x'

  has_command(:oneimage, 'oneimage') do
    environment HOME: '/root', ONE_AUTH: '/var/lib/one/.one/one_auth'
  end

  mk_resource_methods

  # Create a network with onevnet by passing in a temporary template.
  def create
    file = Tempfile.new("oneimage-#{resource[:name]}")
    File.chmod(0644, file.path)

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.IMAGE do
        xml.NAME resource[:name]
        xml.DESCRIPTION resource[:description] if resource[:description]
        xml.TYPE resource[:type].to_s.upcase if resource[:type]
        xml.PERSISTENT (resource[:persistent] ? 'yes' : 'no') if resource[:persistent]
        xml.DEV_PREFIX resource[:dev_prefix] if resource[:dev_prefix]
        xml.DRIVER resource[:driver] if resource[:driver]
        xml.PATH resource[:path] if resource[:path]
        xml.SOURCE resource[:source] if resource[:source]
        xml.FSTYPE resource[:fstype] if resource[:fstype]
        xml.SIZE resource[:size] if resource[:size]
        xml.TARGET resource[:target] if resource[:target]
      end
    end
    tempfile = builder.to_xml
    file.write(tempfile)
    file.close
    self.debug "Creating image using tempfile: #{tempfile}"
    oneimage('create', '-d', resource[:datastore], file.path)
    @property_hash[:ensure] = :present
  end

  # Destroy a network using onevnet delete
  def destroy
    oneimage('delete', resource[:name])
    @property_hash.clear
  end

  # Check if a network exists by scanning the onevnet list
  def exists?
    @property_hash[:ensure] == :present
  end

  # Return the full hash of all existing oneimage resources
  def self.instances
    images = Nokogiri::XML(oneimage('list', '-x')).root.xpath('/IMAGE_POOL/IMAGE').map
    images.collect do |image|
      new(
        name:           image.xpath('./NAME').text,
        ensure:         :present,
        datastore:      image.xpath('./DATASTORE').text,
        description:    image.xpath('./TEMPLATE/DESCRIPTION').text,
        dev_prefix:     image.xpath('./TEMPLATE/DEV_PREFIX').text,
        driver:         (image.xpath('./TEMPLATE/DRIVER').text unless image.xpath('./TEMPLATE/DRIVER').nil?),
        fstype:         (image.xpath('./TEMPLATE/FSTYPE').text unless image.xpath('./TEMPLATE/FSTYPE').nil?),
        path:           image.xpath('./TEMPLATE/PATH').text || image.xpath('./PATH').text,
        persistent:     { '1' => :true, '0' => :false }[image.xpath('./PERSISTENT').text],
        size:           image.xpath('./SIZE').text,
        source:         (image.xpath('./TEMPLATE/SOURCE') || image.xpath('./SOURCE')).text,
        target:         (image.xpath('./TEMPLATE/TARGET').text unless image.xpath('./TEMPLATE/TARGET').nil?),
        type:           { '0' => :OS, '1' => :CDROM, '2' => :DATABLOCK, '5' => :CONTEXT }[image.xpath('./TYPE').text],
      )
    end
  end

  def self.prefetch(resources)
    images = instances
    resources.keys.each do |name|
      provider = images.find { |image| image.name == name }
      resources[name].provider = provider unless provider.nil?
    end
  end

  # setters
  def datastore=(value)
    raise 'Can not modify datastore on images'
  end
  def type=(value)
    raise 'Can not modify type of images'
  end
  def persistent=(value)
    raise 'Can not make images persistent'
  end
  def dev_prefix=(value)
    raise 'Can not modify dev_prefix on images'
  end
  def target=(value)
    raise 'Can not modify target of images'
  end
  def path=(value)
    raise 'Can not modify path of images'
  end
  def driver=(value)
    raise 'Can not modify driver of images'
  end
  def disk_type=(value)
    raise 'Can not modify disk_type of images'
  end
  def source=(value)
    raise 'Can not modify source of images'
  end
  def size=(value)
    raise 'Can not modify size of images'
  end
  def fstype=(value)
    raise 'Can not modify fstype of images'
  end

end
