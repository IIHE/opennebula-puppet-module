shared_examples 'a puppet type' do |parameter_tests, res_type_name|
  res_type = Puppet::Type.type(res_type_name)

  let(:resource) { described_class.new(name: 'test') }

  parameter_tests.each do |param, tests|
    describe "parameter #{param}" do
      it 'exists' do
        expect { resource[param] }.to_not raise_error
      end

      if tests.key?(:default)
        it "has a default of #{tests[:default]}" do
          expect(resource[param]).to eq(tests[:default])
        end
      else
        pending('should have a default')
      end

      if tests[:valid]
        tests[:valid].each do |test_value|
          it "allows a valid value, for example: #{test_value}" do
            expect { resource[param] = test_value }.to_not raise_error
            expect(resource[param]).to eq(test_value)
          end
        end
      else
        pending('should accept valid values')
      end

      if tests[:invalid]
        tests[:invalid].each do |test_value|
          it "throws an error for an invalid value, for example: #{test_value.inspect}" do
            expect { resource[param] = test_value }.to raise_error(Puppet::Error)
          end
        end
      else
        pending('should throw an error for invalid values')
      end

      if (prop = res_type.propertybyname(param))
        it 'has docs' do
          expect(prop.doc).not_to be_nil
          expect(prop.doc).not_to eq('')
        end
      end
    end
  end
end
