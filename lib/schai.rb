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

  def self.path
    @@path ||=[]
  end

  def self.parse_file path
    if Schai.path.empty?
      Schai.path << path
      ret = parse YAML.load_file(path)
      Schai.path.pop
    else
      expand_path = File.expand_path("../#{path}", Schai.path.last)
      Schai.path << expand_path
      ret = parse YAML.load_file(expand_path)
      Schai.path.pop
    end
    ret
  end
end
