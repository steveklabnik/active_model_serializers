require 'active_support/core_ext/class/attribute'

module ActionController
  module Serialization
    extend ActiveSupport::Concern

    include ActionController::Renderers

    def _render_option_json(resource, options)
      serializer = ActiveModel::Serializer.serializer_for(resource)

      if serializer
        object = serializer.new(resource)
        adapter = ActiveModel::Serializer.default_adapter.new(object)

        super(adapter, options)
      else
        super
      end
    end
  end
end
