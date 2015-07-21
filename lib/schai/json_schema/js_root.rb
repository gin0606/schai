module Schai
  class JsRoot
    attr_accessor :schema

    def self.parse params
      ret = self.new
      ret.schema = parse_components params
      ret
    end

    def self.parse_components params
      case
      when params.has_key?('include')
        included_schema = Schai.parse_file(params.delete('include')).schema
        params.each do |k, v|
          setter = "#{k}=".to_sym
          included_schema.send(setter, v)
        end
        included_schema
      when params['type'] == 'object'
        JsObject.parse params
      when params['type'] == 'array'
        JsArray.parse params
      when !params.has_key?('type')
        raise "typeは必須(#{params})"
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
