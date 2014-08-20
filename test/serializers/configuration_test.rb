require 'test_helper'

module ActiveModel
  class Serializer
    class ConfigurationTest < Minitest::Test
      DummyAdapter = Class.new

      def setup
        ActiveModel::Serializer.default_adapter = nil
      end

      # Make sure to reset the default_adapter. This configuration was
      # carrying forward for other tests causing random test failures.
      def teardown
        ActiveModel::Serializer.default_adapter = nil
      end

      def test_default_adapter
        assert_equal(ActiveModel::Serializer::Adapter::NullAdapter,
                     ActiveModel::Serializer.default_adapter)
      end

      def test_setting_different_default_adapter
        ActiveModel::Serializer.default_adapter = DummyAdapter
        assert_equal(DummyAdapter,
                     ActiveModel::Serializer.default_adapter)
      end
    end
  end
end
