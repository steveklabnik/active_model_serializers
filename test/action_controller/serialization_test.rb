require 'test_helper'

module ActionController
  module Serialization
    class ImplicitSerializerTest < ActionController::TestCase
      class MyController < ActionController::Base
        def render_using_implicit_serializer
          render json: Profile.new({ name: 'Name 1', description: 'Description 1', comments: 'Comments 1' })
        end
      end

      tests MyController

      # We just have Null for now, this will change
      def test_render_using_implicit_serializer
        ActiveModel::Serializer.default_adapter = ActiveModel::Serializer::Adapter::NullAdapter
        get :render_using_implicit_serializer

        assert_equal 'application/json', @response.content_type
        assert_equal '{"name":"Name 1","description":"Description 1"}', @response.body
      end
    end

    class ExplicitSerializerTest < ActionController::TestCase
      class ExplicitProfileSerializer < ActiveModel::Serializer
        attributes :name
      end
      
      class MyController < ActionController::Base
        def render_using_explicit_serializer
          render json: Profile.new({ name: 'Name 1', description: 'Description 1', comments: 'Comments 1' }), serializer: ExplicitProfileSerializer 
        end
      end
      
      tests MyController

      def test_render_using_explicit_serializer
        get :render_using_explicit_serializer

        assert_equal 'application/json', @response.content_type
        assert_equal '{"name":"Name 1"}', @response.body
      end
    end
  end
end

