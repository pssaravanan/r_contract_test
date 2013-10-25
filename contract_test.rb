require 'yaml'
require 'net/http'
require 'uri'
require 'json-schema'


end_point_file = "#{File.dirname(__FILE__)}/endpoints.yml"
end_points = YAML.load_file(end_point_file)

def get_json url
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri)
  response.body
end

def schema_file schema_name
  "#{File.dirname(__FILE__)}/json_schema/#{schema_name}.json"
end

end_points.each do |scenario|
  json_data = get_json scenario["url"]
  schema_file = schema_file(scenario["schema"])
  errors = JSON::Validator.fully_validate(schema_file, json_data)
  p "URL:#{scenario['url']}"
  errors.each{|err| p err}
  p "*"*100
end

