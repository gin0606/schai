require 'yaml'
require 'json'

module Schai
  module Optional
    attr_accessor :optional
  end

  module Metadata
    attr_accessor :description, :example
  end

  def self.parse params
    Root.parse params
  end

  def self.parse_file path
    @@path ||=[]
    if @@path.empty?
      @@path << path
      ret = parse YAML.load_file(path)
      @@path.pop
    else
      expand_path = File.expand_path("../#{path}", @@path.last)
      @@path << expand_path
      ret = parse YAML.load_file(expand_path)
      @@path.pop
    end
    ret
  end

  class Root
    attr_accessor :schema

    def self.parse params
      ret = self.new
      ret.schema = parse_components params
      ret
    end

    def self.parse_components params
      case
      when params.has_key?('include')
        Schai.parse_file(params['include']).schema
      when params['type'] == 'object'
        Object.parse params
      when params['type'] == 'array'
        Array.parse params
      when !params.has_key?('type')
        raise "typeは必須(#{params})"
      else
        Schai::Property.parse params
      end
    end

    def to_schema
      schema = {
        '$schema': "http://json-schema.org/draft-04/schema#"
      }
      schema.merge @schema.to_schema
    end
  end

  class Object
    include Optional
    include Metadata

    attr_accessor :all

    def self.parse params
      self.new params
    end

    def initialize params
      @all = Hash[params["properties"].map {|k, v|
        [k || 'null', Root.parse_components(v)]
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

  class Array
    include Optional
    include Metadata

    attr_accessor :items
    def self.parse params
      self.new params
    end

    def initialize params
      @items = Property.parse params['items']
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

  class Property
    include Optional
    include Metadata

    attr_accessor :type, :format

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
