module Occi
  module Core
    module Helpers
      describe ArgumentValidator do
        subject(:validatable_object) { object_with_av }

        let(:object_with_av) { RocciCoreSpec::ArgumentValidatorTestObject.new }

        describe '#default_args!' do
          let(:args) { { val: 'test' } }
          let(:no_val_args) { { text: 'mine' } }
          let(:empty_text_args) { { text: nil, val: '' } }

          it 'sets default argument value' do
            expect { validatable_object.send(:default_args!, args) }.not_to raise_error
            expect(args[:text]).to eq 'text'
          end

          it 'does not replace given value' do
            expect { validatable_object.send(:default_args!, empty_text_args) }.not_to raise_error
            expect(empty_text_args[:text]).to be nil
          end

          it 'passes with `val` set' do
            expect { validatable_object.send(:default_args!, args) }.not_to raise_error
            expect { validatable_object.send(:default_args!, empty_text_args) }.not_to raise_error
          end

          it 'fails with `val` missing' do
            expect { validatable_object.send(:default_args!, no_val_args) }.to raise_error(RuntimeError)
          end
        end

        describe '#sufficient_args!' do
          it 'does not fail with `val` set' do
            expect { validatable_object.send(:sufficient_args!, val: 'something') }.not_to raise_error
          end

          it 'fails with `val` not set' do
            expect { validatable_object.send(:sufficient_args!, val: nil) }.to raise_error(RuntimeError)
          end
        end

        describe '#defaults' do
          it 'returns a hash-like structure' do
            expect(validatable_object.send(:defaults)).to be_kind_of(Hash)
          end

          it 'contains default value for `text`' do
            expect(validatable_object.send(:defaults).keys).to include(:text)
            expect(validatable_object.send(:defaults)[:text]).to eq 'text'
          end

          it 'does not contain default value for `val`' do
            expect(validatable_object.send(:defaults).keys).to include(:val)
            expect(validatable_object.send(:defaults)[:val]).to be nil
          end

          it 'does not mention `wat`' do
            expect(validatable_object.send(:defaults).keys).not_to include(:wat)
          end
        end
      end
    end
  end
end
