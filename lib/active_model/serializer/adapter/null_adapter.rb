module ActiveModel
  class Serializer
    class Adapter
      class NullAdapter
        def initialize(serializer)
          @serializer = serializer
        end

        def to_json(options={})
          @serializer.attributes.each_with_object({}) do |(attr, value), h|
            h[attr] = value
          end.to_json # FIXME: why does passing options here cause {}?
        end
      end
    end
  end
end
