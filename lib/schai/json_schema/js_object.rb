module Schai
  class JsObject
    attr_accessor :optional, :description, :example, :all

    def self.parse params
      self.new params
    end

    def initialize params
      @all = Hash[params["properties"].map {|k, v|
        [k || 'null', JsRoot.parse_components(v)]
      }]
      @description = params["description"]
      @example = params["example"]
      @optional = params["optional"]
    end

    def to_schema
      schema = {}
      schema[:type] = :object
      schema[:description] = @description if @description
      schema[:properties] = Hash[@all.map {|k, p| [k, p.to_schema]}]
      schema[:required]  = @all.select{|k, p| !p.optional}.map{|k, p| k || 'null'}
      schema[:example] = @example if @example
      schema
    end
  end
end
