# Usage:
#   # The json is result of RuboCop in Readmine project
#   $ ruby large.rb json
#
# Result:
#                            user     system      total        real
# StrongJSON            11.140000   0.020000  11.160000 ( 11.152806)
# MightyJSON             4.340000   0.010000   4.350000 (  4.355610)
#
# Environment:
#   - StrongJSON: v0.4.0
#   - MightyJSON: 7c4c34fff3e24a9573bc8397985d4080eee87359
#   - Ruby 2.4.1
#   - Arch Linux
#   - Core i7-6700K

require 'json'
require 'mighty_json'
require 'strong_json'
require 'benchmark'

s = StrongJSON.new do
  let :metadata, object(rubocop_version: string, ruby_engine: string, ruby_version: string, ruby_patchlevel: string, ruby_platform: string)
  let :offense, object(severity: string, message: string, cop_name: string, corrected: boolean, location: object(line: number, column: number, length: number))
  let :file, object(path: string, offenses: array(offense))
  let :summary, object(offense_count: number, target_file_count: number, inspected_file_count: number)

  let :o, object(metadata: metadata, files: array(file), summary: summary)
end

m = MightyJSON.new do
  let :metadata, object(rubocop_version: string, ruby_engine: string, ruby_version: string, ruby_patchlevel: string, ruby_platform: string)
  let :offense, object(severity: string, message: string, cop_name: string, corrected: boolean, location: object(line: number, column: number, length: number))
  let :file, object(path: string, offenses: array(offense))
  let :summary, object(offense_count: number, target_file_count: number, inspected_file_count: number)

  let :o, object(metadata: metadata, files: array(file), summary: summary)
end

data = JSON.parse ARGF.read, symbolize_names: true

raise 'Invalid' if s.o.coerce(data) != m.o.coerce(data)

Benchmark.bm(20) do |x|
  x.report('StrongJSON'){20.times{s.o.coerce(data)}}
  x.report('MightyJSON'){20.times{m.o.coerce(data)}}
end
