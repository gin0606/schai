module Schai
  class JsProperty
    attr_accessor :optional, :description, :example, :type, :format

    def self.parse params
      if params.has_key? 'include'
        Schai.parse_file(params['include']).schema
      else
        self.new params
      end
    end

    def initialize params
      params.each do |k, v|
        setter = "#{k}=".to_sym
        self.send(setter, v)
      end
    end

    def to_schema
      ret = {}
      ret[:type] = (@type || 'null').to_sym
      ret[:format] = @format if @format
      ret[:description] = @description if @description
      ret[:example] = @example if @example
      ret
    end
  end
end
