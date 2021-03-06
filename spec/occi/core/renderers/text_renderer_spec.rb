module Occi
  module Core
    module Renderers
      describe TextRenderer do
        subject(:trc) { TextRenderer }

        it 'has logger' do
          expect(trc).to respond_to(:logger)
        end

        describe '::renderer?' do
          it 'return true' do
            expect(trc.renderer?).to be true
          end
        end

        describe '::formats' do
          it 'return non-empty enumerable' do
            expect(trc.formats).not_to be_empty
            expect(trc.formats).to be_kind_of(Enumerable)
          end
        end

        describe '::render' do
          before do
            trc.known_serializers.each do |s|
              id = instance_double(s.to_s)
              allow(id).to receive(:render)
              allow(s).to receive(:new).with(kind_of(Object), instance_of(Hash)).and_return(id)
            end
          end

          context 'with known type' do
            let(:obj) { Occi::Core::Category.new(term: 'cat', schema: 'http://test.schema.org/test#') }

            it 'delegates to serializer' do
              expect { trc.render(obj, {}) }.not_to raise_error
            end
          end

          context 'with unknown type' do
            let(:obj) { Object.new }

            it 'raises error' do
              expect { trc.render(obj, {}) }.to raise_error(Occi::Core::Errors::RenderingError)
            end
          end
        end

        describe '::known_types' do
          it 'returns enumerable' do
            expect(trc.known_types).to be_kind_of(Enumerable)
          end

          it 'is not empty' do
            expect(trc.known_types).not_to be_empty
          end

          it 'returns strings' do
            expect(trc.known_types).to all(be_kind_of(String))
          end
        end

        describe '::known_serializers' do
          it 'returns enumerable' do
            expect(trc.known_serializers).to be_kind_of(Enumerable)
          end

          it 'is not empty' do
            expect(trc.known_serializers).not_to be_empty
          end

          it 'returns classes' do
            expect(trc.known_serializers).to all(be_kind_of(Class))
          end
        end

        describe '::known' do
          it 'returns enumerable' do
            expect(trc.known).to be_kind_of(Hash)
          end

          it 'is not empty' do
            expect(trc.known).not_to be_empty
          end
        end
      end
    end
  end
end
