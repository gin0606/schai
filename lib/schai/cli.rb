require 'schai'
require 'thor'

module Schai
  class CLI < Thor
    desc "hello", "say 'hello world!'."
    def hello
      puts "Hello World!"
    end

    desc "gen", "generate json schema from yaml"
    option :yaml, :require => true
    option :to, :require => false
    def gen
      schai = Schai.parse_file options[:yaml]

      json = JSON.pretty_generate(schai.to_schema)
      if dist_file = options[:to]
        File.open(dist_file, "w") {|f| f.puts json}
      else
        puts json
      end
    end
  end
end
