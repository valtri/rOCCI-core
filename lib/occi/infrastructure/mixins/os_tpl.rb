module Occi
  module Infrastructure
    module Mixins
      # A helper class for manipulation with `os_tpl` parent mixin. Doesn't
      # provide any additional functionality aside from the class name.
      #
      # @author Boris Parak <parak@cesnet.cz>
      class OsTpl < Occi::Core::Mixin
        TERM   = 'os_tpl'.freeze
        SCHEMA = 'http://schemas.ogf.org/occi/infrastructure#'.freeze
        TITLE  = 'OS or Appliance template (parent mixin)'.freeze

        # See `Occi::Core::Mixin` and `Occi::Core::Category`
        def initialize
          super term: TERM, schema: SCHEMA, title: TITLE
        end
      end
    end
  end
end
