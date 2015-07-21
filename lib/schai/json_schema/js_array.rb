module Schai
  class JsArray
    attr_accessor :optional, :description, :example, :items

    def self.parse params
      self.new params
    end

    def initialize params
      @items = JsProperty.parse params['items']
      @description = params["description"]
      @example = params["example"]
      @optional = params["optional"]
    end

    def to_schema
      schema = {
        type: :array,
      }
      schema[:description] = @description if @description
      schema[:items] = @items.to_schema
      schema[:example] = @example if @example
      schema
    end
  end
end
