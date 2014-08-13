module ActiveModel
  class Serializer
    class << self
      attr_accessor :_attributes
      attr_writer :default_adapter

      def default_adapter
        @default_adapter || Adapter::NullAdapter
      end
    end

    def self.inherited(base)
      base._attributes = []
    end
   
    # Define the list of attributes to serialize
    #
    # For each symbol passed, check to see if the model
    # has a matching method defined. Otherwise, define a 
    # new method which calls `read_attribute_for_serialization`
    # 
    # @param [Symbol] attrs
    #   the attr to define a new method for
    #
    # @api public
    def self.attributes(*attrs)
      @_attributes.concat attrs

      attrs.each do |attr|
        define_method attr do
          object.read_attribute_for_serialization(attr)
        end unless method_defined?(attr)
      end
    end

    if RUBY_VERSION >= '2.0' 
    # Returns constantized serial class, for a given resource
    #
    # @param [Object] resource
    #   the resource to find a matching serializer for
    #
    # @api public
      def self.serializer_for(resource)
        if resource.respond_to?(:to_ary)
          ArraySerializer
        else
          begin
            Object.const_get "#{resource.class.name}Serializer"
          rescue NameError
            nil
          end
        end
      end
    else
      def self.serializer_for(resource)
        if resource.respond_to?(:to_ary)
          ArraySerializer
        else
          "#{resource.class.name}Serializer".safe_constantize
        end
      end
    end 

    attr_accessor :object
    
    def initialize(object)
      @object = object
    end

    # Returns a hash of attributes defined by `self.attributes(*attrs)`
    # 
    # @api public
    def attributes
      self.class._attributes.dup.each_with_object({}) do |name, hash|
        hash[name] = send(name)
      end
    end
  end
end
