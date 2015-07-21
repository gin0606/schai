require "schai/version"
require "schai/root"
require "schai/object"
require "schai/array"
require "schai/property"
require "schai/cli"
require "yaml"

module Schai
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
end
