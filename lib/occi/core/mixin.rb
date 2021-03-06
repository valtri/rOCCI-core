module Occi
  module Core
    # Defines the extension mechanism of the OCCI Core Model. The
    # `Mixin` instance can be used to add `actions`, `attributes`,
    # and custom features to existing `Entity` instances based on
    # a specific `Kind` instance. A `Mixin` instance may depend
    # on other `Mixin` instances (see `#depends`) and may be applied
    # only to `Entity` instances based on specified `Kind` instances
    # (see `#applies`). Some `Mixin` instances have special meaning
    # defined in OCCI Standard documents.
    #
    # @attr actions [Set] list of `Action` instances attached to this mixin instance
    # @attr depends [Set] list of `Mixin` instances on which this mixin depends
    # @attr applies [Set] list of `Kind` instances to which this mixin can be applied
    # @attr location [URI] protocol agnostic location of this mixin instance
    #
    # @author Boris Parak <parak@cesnet.cz>
    class Mixin < Category
      include Helpers::Locatable

      attr_accessor :actions, :depends, :applies
      attr_writer :location

      # Checks whether the given mixin is in the dependency
      # chains of this instance. Checking for dependencies
      # is strictly flat (no transitivity is applied). One
      # `Mixin` instance may depend on multiple other instances.
      #
      # @param mixin [Mixin] candidate instance
      # @return [TrueClass, FalseClass] result
      def depends?(mixin)
        return false unless depends && mixin
        depends.include? mixin
      end

      # Checks whether the given kind is in the applies
      # set of this instance (i.e., this mixin can be applied
      # to an `Entity` instance of the given kind). Checking
      # for applicable kinds is strictly flat (no transitivity
      # is applied). One `Mixin` instance may be applied to
      # multiple kinds (`Entity` instances of the given kind).
      #
      # @param kind [Kind] candidate instance
      # @return [TrueClass, FalseClass] result
      def applies?(kind)
        return false unless applies && kind
        applies.include? kind
      end

      protected

      # :nodoc:
      def defaults
        super.merge(actions: Set.new, depends: Set.new, applies: Set.new, location: nil)
      end

      # :nodoc:
      def sufficient_args!(args)
        super
        %i[actions depends applies].each do |attr|
          if args[attr].nil?
            raise Occi::Core::Errors::MandatoryArgumentError, "#{attr} is a mandatory " \
                  "argument for #{self.class}"
          end
        end
      end

      # :nodoc:
      def post_initialize(args)
        super
        @actions = args.fetch(:actions)
        @depends = args.fetch(:depends)
        @applies = args.fetch(:applies)
        @location = args.fetch(:location)
      end

      private

      # Generates default location based on the already configured
      # `term` attribute. Fails if `term` is not present.
      #
      # @example
      #   mixin.term              # => 'compute'
      #   mixin.generate_location # => #<URI::Generic /mixin/compute/>
      #
      # @return [URI] generated location string
      def generate_location
        if term.blank?
          raise Occi::Core::Errors::MandatoryArgumentError,
                'Cannot generate default location without a `term`'
        end
        URI.parse "/mixin/#{term}/"
      end
    end
  end
end
