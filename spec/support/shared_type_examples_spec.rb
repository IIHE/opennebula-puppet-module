shared_examples 'a puppet type' do |parameter_tests, res_type_name|
  res_type = Puppet::Type.type(res_type_name)

  let(:provider) {
    prov = stub 'provider'
    # prov.stubs(:name).returns(res_type_name)
    if res_type_name == :onehost then
      prov.stubs(:name).returns('cli_5_0')
    else
      prov.stubs(:name).returns('cli')
    end
    prov
  }
  let(:type) {
    val = res_type
    val.stubs(:defaultprovider).returns provider
    val
  }
  let(:resource) {
    type.new({ name: 'test' })
  }

  parameter_tests.each do |param, tests|
    describe "parameter #{param}" do
      it 'exists' do
        expect { resource[param] }.to_not raise_error
      end

      if tests.has_key?(:default) then
        it "has a default of #{tests[:default]}" do
          resource[param].should == tests[:default]
        end
      else
        pending('should have a default')
      end

      if tests[:valid] then
        tests[:valid].each do |test_value|
          it "allows a valid value, for example: #{test_value}" do
            expect { resource[param] = test_value }.to_not raise_error
            resource[param].should == test_value
          end
        end
      else
        pending('should accept valid values')
      end

      if tests[:invalid] then
        tests[:invalid].each do |test_value|
          it "throws an error for an invalid value, for example: #{test_value.inspect}" do
            expect { resource[param] = test_value }.to raise_error()
          end
        end
      else
        pending('should throw an error for invalid values')
      end

      if prop = res_type.propertybyname(param) then
        it 'has docs' do
          prop.doc.should_not == nil
          prop.doc.should_not == ''
        end
      end
    end
  end
end
