# Usage:
#   # The json is result of RuboCop in Readmine project
#   # https://drive.google.com/file/d/0B0yU5j3W2zM9WW53b01jaWhFZHc/view?usp=sharing
#   $ ruby realtime.rb json

require 'json'
require 'mighty_json'
require 'benchmark'

m = MightyJSON.new do
  let :metadata, object(rubocop_version: string, ruby_engine: string, ruby_version: string, ruby_patchlevel: string, ruby_platform: string)
  let :offense, object(severity: string, message: string, cop_name: string, corrected: boolean, location: object(line: number, column: number, length: number))
  let :file, object(path: string, offenses: array(offense))
  let :summary, object(offense_count: number, target_file_count: number, inspected_file_count: number)

  let :o, object(metadata: metadata, files: array(file), summary: summary)
end

data = JSON.parse ARGF.read, symbolize_names: true

time = Benchmark.realtime do
  20.times{m.o.coerce(data)}
end
p time
