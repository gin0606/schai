require "schai/version"
require "schai/json_schema/js_root"
require "schai/json_schema/js_object"
require "schai/json_schema/js_array"
require "schai/json_schema/js_property"
require "schai/cli"
require "yaml"

module Schai
  def self.parse params
    JsRoot.parse params
  end

  def self.parse_file path
    @@path ||=[]

    YAML.add_domain_type(nil, "include") do |type, val|
      expand_path = File.expand_path("../#{val}", @@path.last)
      YAML.load_file(expand_path)
    end

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
end
