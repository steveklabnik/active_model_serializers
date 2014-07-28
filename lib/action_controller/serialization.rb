require 'active_support/core_ext/class/attribute'

module ActionController
  module Serialization
    extend ActiveSupport::Concern

    include ActionController::Renderers
    
    # Overrides ActiveController's JSON serialization
    # strategy with our own approach. By default, uses
    # the NullAdapter and a serializer matching the
    # resource passed by the controller.
    #
    # @option options [Class] :serializer A serializer 
    # @option options [Class] :adapter An adapter
    #
    # @api private

    def _render_option_json(resource, options)
      serializer = if options[:serializer]
        options[:serializer]
      else
        ActiveModel::Serializer.serializer_for(resource)
      end

      if serializer
        object = serializer.new(resource)

        adapter = if options[:adapter]
          options[:adapter]
        else
          ActiveModel::Serializer.default_adapter.new(object)
        end.new(object)

        super(adapter, options)
      else
        super
      end
    end
  end
end
