module Schai
  class JsRoot
    attr_accessor :schema

    def self.parse params
      self.new.tap do |js_root|
        js_root.schema = parse_components params
      end
    end

    def self.parse_components params
      # include other .yaml file
      if params.has_key?('include')
        included_schema = Schai.parse_file(params.delete('include')).schema
        params.each do |k, v|
          setter = "#{k}=".to_sym
          included_schema.send(setter, v)
        end
        return included_schema
      end

      raise "typeは必須(#{params})" unless params.has_key?('type')
      case params['type']
      when 'object'
        JsObject.parse params
      when 'array'
        JsArray.parse params
      else
        JsProperty.parse params
      end
    end

    def to_schema
      schema = {
        '$schema': "http://json-schema.org/draft-04/schema#"
      }
      schema.merge @schema.to_schema
    end
  end
end
