module Occi
  describe Collection do

    context 'initialization' do
      let(:collection){ collection = Occi::Collection.new }
      
      context 'with base objects' do
        before(:each) {
          collection.kinds << "http://schemas.ogf.org/occi/infrastructure#compute"
          collection.mixins << "http://example.com/occi/tags#my_mixin"
          collection.actions << "http://schemas.ogf.org/occi/infrastructure/compute/action#start"
          collection.action = Occi::Core::ActionInstance.new
          collection.resources << Occi::Core::Resource.new
          collection.links << Occi::Core::Link.new
        }

        it 'calssifies kind correctly' do
          expect(collection.kinds.first).to be_kind_of Occi::Core::Kind
        end

        it 'calssifies mixin correctly' do
          expect(collection.mixins.first).to be_kind_of Occi::Core::Mixin
        end

        it 'calssifies action correctly' do
          expect(collection.actions.first).to be_kind_of Occi::Core::Action
        end

        it 'calssifies resource correctly' do
          expect(collection.resources.first).to be_kind_of Occi::Core::Resource
        end

        it 'calssifies link correctly' do
          expect(collection.links.first).to be_kind_of Occi::Core::Link
        end

        it 'calssifies action instance correctly' do
          expect(collection.action).to be_kind_of Occi::Core::ActionInstance
        end
      end
    end
      
    context '#model' do
      let(:collection){ collection = Occi::Collection.new }
      it 'registers a model' do
        expect(collection.model).to be_kind_of Occi::Model
      end
    end
      
    context '#resources' do
      let(:collection){ collection = Occi::Collection.new }
      it 'can create a new OCCI Resource' do
        collection.resources.create 'http://schemas.ogf.org/occi/core#resource'
        expect(collection.resources.first).to be_kind_of Occi::Core::Resource
      end
    end

    context '#check' do
      let(:collection){ collection = Occi::Collection.new }
      it 'checks against model without failure' do
        collection.resources.create 'http://schemas.ogf.org/occi/core#resource'
        expect{ collection.check }.to_not raise_error
      end
    end

    context '#get_related_to' do
      let(:collection){ collection = Occi::Collection.new }
      before(:each){
        collection.kinds << Occi::Core::Resource.kind
        collection.kinds << Occi::Core::Link.kind
      }
      it 'gets Entity as a related kind' do
        expect(collection.get_related_to(Occi::Core::Entity.kind)).to eql collection
      end

      it 'gets Resource as a related kind' do
        expect(collection.get_related_to(Occi::Core::Resource.kind).kinds.first).to eql Occi::Core::Resource.kind
      end

      it 'gets Link as a related kind' do
        expect(collection.get_related_to(Occi::Core::Link.kind).kinds.first).to eql Occi::Core::Link.kind
      end
    end

    context '#merge' do
      let(:collection){ collection = Occi::Collection.new }
      before(:each) {
        collection.kinds << "http://schemas.ogf.org/occi/infrastructure#compute"
        collection.mixins << "http://example.com/occi/tags#my_mixin"
        collection.actions << "http://schemas.ogf.org/occi/infrastructure/compute/action#start"
        collection.action = Occi::Core::ActionInstance.new
        collection.resources << Occi::Core::Resource.new
        collection.links << Occi::Core::Link.new
      }
      context 'two fully initiated collections' do
        let(:action){ Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/core/entity/action#', term='testaction', title='testaction action' }
        let(:coll2){
          coll2 = Occi::Collection.new
          coll2.kinds << "http://schemas.ogf.org/occi/infrastructure#storage"
          coll2.mixins << "http://example.com/occi/tags#another_mixin"
          coll2.actions << "http://schemas.ogf.org/occi/infrastructure/compute/action#stop"
          coll2.action = Occi::Core::ActionInstance.new action
          coll2.resources << Occi::Core::Resource.new
          coll2.links << Occi::Core::Link.new
          coll2
        }
        let(:merged){ collection.merge(coll2, collection) }

        context 'resulting collection' do
          it 'has the correct number of kinds' do
            expect(merged.kinds.count).to eql 2
          end

          it 'has the correct number of mixins' do
            expect(merged.mixins.count).to eql 2
          end

          it 'has the correct number of actions' do
            expect(merged.actions.count).to eql 2
          end

          it 'has the correct number of resources' do
            expect(merged.resources.count).to eql 2
          end

          it 'has the correct number of links' do
            expect(merged.links.count).to eql 2
          end

          it 'inherits action from the other collection' do
            expect(merged.action.action.term).to eql "testaction"
          end

          it 'does not inherit action from first collection' do
            expect(merged.action.action.term).to_not eql "action_instance"
          end

          it 'holds kinds from first collection' do
            expect(collection.kinds.subset?(merged.kinds)).to eql true
          end

          it 'holds mixins from first collection' do
            expect(collection.mixins.subset?(merged.mixins)).to eql true
          end

          it 'holds actions from first collection' do
            expect(collection.actions.subset?(merged.actions)).to eql true
          end

          it 'holds resources from first collection' do
            expect(collection.resources.subset?(merged.resources)).to eql true
          end

          it 'holds links from first collection' do
            expect(collection.links.subset?(merged.links)).to eql true
          end

          it 'holds kinds from other collection' do
            expect(coll2.kinds.subset?(merged.kinds)).to eql true
          end

          it 'holds mixins from other collection' do
            expect(coll2.mixins.subset?(merged.mixins)).to eql true
          end

          it 'holds actions from other collection' do
            expect(coll2.actions.subset?(merged.actions)).to eql true
          end

          it 'holds resources from other collection' do
            expect(coll2.resources.subset?(merged.resources)).to eql true
          end

          it 'holds links from other collection' do
            expect(coll2.links.subset?(merged.links)).to eql true
          end

          it 'does not replace first collection' do
            expect(merged).to_not eql collection
          end
        end

        context 'first original' do
          it 'kept the correct number of kinds' do
            expect(collection.kinds.count).to eql 1
          end

          it 'kept the correct number of mixins' do
            expect(collection.mixins.count).to eql 1
          end

          it 'kept the correct number of actions' do
            expect(collection.actions.count).to eql 1
          end

          it 'kept the correct number of resources' do
            expect(collection.resources.count).to eql 1
          end

          it 'kept the correct number of links' do
            expect(collection.links.count).to eql 1
          end
        end

        context 'second original' do
          it 'kept the correct number of kinds' do
            expect(coll2.kinds.count).to eql 1
          end

          it 'kept the correct number of mixins' do
            expect(coll2.mixins.count).to eql 1
          end
        
          it 'kept the correct number of actions' do
            expect(coll2.actions.count).to eql 1
          end

          it 'kept the correct number of resources' do
            expect(coll2.resources.count).to eql 1
          end

          it 'kept the correct number of links' do
            expect(coll2.links.count).to eql 1
          end
        end
      end

      it 'copes with en empty collection' do
        emptycol = Occi::Collection.new
        expect{merged = collection.merge(emptycol, collection)}.to_not raise_error
      end


      it 'copes with both collections empty'

    context '#merge!' do
      let(:collection){ collection = Occi::Collection.new 
        collection.kinds << "http://schemas.ogf.org/occi/infrastructure#compute"
        collection.mixins << "http://example.com/occi/tags#my_mixin"
        collection.actions << "http://schemas.ogf.org/occi/infrastructure/compute/action#start"
        collection.action = Occi::Core::ActionInstance.new
        collection.resources << Occi::Core::Resource.new
        collection.links << Occi::Core::Link.new
        collection
      }
      context 'two fully initiated collections' do
        let(:action){ Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/core/entity/action#', term='testaction', title='testaction action' }
        let(:coll2){
          coll2 = Occi::Collection.new
          coll2.kinds << "http://schemas.ogf.org/occi/infrastructure#storage"
          coll2.mixins << "http://example.com/occi/tags#another_mixin"
          coll2.actions << "http://schemas.ogf.org/occi/infrastructure/compute/action#stop"
          coll2.action = Occi::Core::ActionInstance.new action
          coll2.resources << Occi::Core::Resource.new
          coll2.links << Occi::Core::Link.new
          coll2
        }
        before(:each) { collection.merge!(coll2) }
        context 'resulting collection' do
          it 'has the correct number of kinds' do
            expect(collection.kinds.count).to eql 2
          end

          it 'has the correct number of mixins' do
            expect(collection.mixins.count).to eql 2
          end

          it 'has the correct number of actions' do
            expect(collection.actions.count).to eql 2
          end

          it 'has the correct number of resources' do
            expect(collection.resources.count).to eql 2
          end

          it 'has the correct number of links' do
            expect(collection.links.count).to eql 2
          end

          it 'inherits action from the other collection' do
            expect(collection.action.action.term).to eql "testaction"
          end

          it 'does not inherit action from first collection' do
            expect(collection.action.action.term).to_not eql "action_instance"
          end

          it 'holds kinds from other collection' do
            expect(coll2.kinds.subset?(collection.kinds)).to eql true
          end

          it 'holds mixins from other collection' do
            expect(coll2.mixins.subset?(collection.mixins)).to eql true
          end

          it 'holds actions from other collection' do
            expect(coll2.actions.subset?(collection.actions)).to eql true
          end

          it 'holds resources from other collection' do
            expect(coll2.resources.subset?(collection.resources)).to eql true
          end

          it 'holds links from other collection' do
            expect(coll2.links.subset?(collection.links)).to eql true
          end
        end

        context 'the other collection' do
          it 'kept the correct number of kinds' do
            expect(coll2.kinds.count).to eql 1
          end

          it 'kept the correct number of mixins' do
            expect(coll2.mixins.count).to eql 1
          end
        
          it 'kept the correct number of actions' do
            expect(coll2.actions.count).to eql 1
          end

          it 'kept the correct number of resources' do
            expect(coll2.resources.count).to eql 1
          end

          it 'kept the correct number of links' do
            expect(coll2.links.count).to eql 1
          end
        end
      end
    end

    end

  end
end
