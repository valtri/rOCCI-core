module Occi
  module InfrastructureExt
    # Dummy sub-class of `Occi::Core::Resource` meant to simplify handling
    # of known instances of the given sub-class. Does not contain any functionality.
    #
    # @author Boris Parak <parak@cesnet.cz>
    class SecurityGroup < Occi::Core::Resource; end
  end
end
