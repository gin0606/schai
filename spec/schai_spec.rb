require 'spec_helper'

describe Schai do
  it 'has a version number' do
    expect(Schai::VERSION).not_to be nil
  end

  it 'can parse yaml' do
    properties = Schai.parse_file "spec/fixtures/obj.yaml"
    expect(properties.to_schema).not_to be nil
    expect(JSON.pretty_generate properties.to_schema).not_to be nil
  end

  it 'can parse basic types' do
    types = %i(boolean integer number null string)
    types.each do |type|
      yaml = <<-YAML
      type: #{type}
      YAML
      schema = Schai.parse(YAML.load yaml).to_schema
      expect(schema[:type]).to eq type
    end
  end

  it 'can parse object type' do
    yaml = <<-YAML
    type: object
    description: this is description
    properties:
      property:
        description: this is property description
        type: string
    YAML
    schema = Schai.parse(YAML.load yaml).to_schema
    expect(schema[:type]).to eq :object
    expect(schema[:description]).to eq 'this is description'
    expect(schema[:properties].length).not_to be 0
    expect(schema[:properties]["property"][:type]).to eq :string
    expect(schema[:properties]["property"][:description]).to eq 'this is property description'
    expect(schema[:required]).to include("property")
  end

  it '`required` dont include optional properties' do
    yaml = <<-YAML
    type: object
    description: this is description
    properties:
      optional_property:
        type: string
        optional: true
      optional_object:
        type: object
        optional: true
        properties:
          p:
            type: string
      optional_array:
        type: array
        optional: true
        items:
          type: string
      required_property:
        type: string
        optional: false
      required_object:
        type: object
        optional: false
        properties:
          p:
            type: string
      required_array:
        type: array
        optional: false
        items:
          type: string
    YAML
    schema = Schai.parse(YAML.load yaml).to_schema
    expect(schema[:required]).to include("required_property")
    expect(schema[:required]).to include("required_object")
    expect(schema[:required]).to include("required_array")
    expect(schema[:required]).not_to include("optional_property")
    expect(schema[:required]).not_to include("optional_object")
    expect(schema[:required]).not_to include("optional_array")
  end

  it 'can parse array type' do
    yaml = <<-YAML
    type: array
    description: this is description
    items:
      type: string
    YAML
    schema = Schai.parse(YAML.load yaml).to_schema
    expect(schema[:type]).to eq :array
    expect(schema[:description]).to eq 'this is description'
    expect(schema[:items][:type]).to eq :string
  end
end
