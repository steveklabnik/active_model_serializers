require 'test_helper'

module ActiveModel
  class Serializer
    class AssocationsTest < Minitest::Test
      def def_serializer(&block)
        Class.new(ActiveModel::Serializer, &block)
      end

      class Model
        def initialize(hash={})
          @attributes = hash
        end

        def read_attribute_for_serialization(name)
          @attributes[name]
        end

        def method_missing(meth, *args)
          if meth.to_s =~ /^(.*)=$/
            @attributes[$1.to_sym] = args[0]
          elsif @attributes.key?(meth)
            @attributes[meth]
          else
            super
          end
        end
      end

      def setup
        @post = Model.new({ title: 'New Post', body: 'Body' })
        @comment = Model.new({ id: 1, body: 'ZOMG A COMMENT' })
        @post.comments = [@comment]
        @post.comment = @comment

        @post_serializer_class = def_serializer do
          attributes :title, :body
        end

        @comment_serializer_class = def_serializer do
          attributes :id, :body
        end

        @post_serializer = @post_serializer_class.new(@post)
      end

      def test_has_many
        @post_serializer_class.class_eval do
          has_many :comments
        end

        assert_equal({comments: {type: :has_many, options: {}}}, @post_serializer.class._associations)
      end

      def test_has_one
        @post_serializer_class.class_eval do
          has_one :comment
        end

        assert_equal({comment: {type: :has_one, options: {}}}, @post_serializer.class._associations)
      end
    end
  end
end

