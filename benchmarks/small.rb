# Usage:
#   $ ruby small.rb
#
# Result:
#                            user     system      total        real
# StrongJSON:object      3.500000   0.000000   3.500000 (  3.498456)
# MightyJSON:object      1.740000   0.000000   1.740000 (  1.737220)
# StrongJSON:string      1.960000   0.000000   1.960000 (  1.962529)
# MightyJSON:string      0.450000   0.000000   0.450000 (  0.447002)
# StrongJSON:array       2.290000   0.000000   2.290000 (  2.295061)
# MightyJSON:array       1.130000   0.000000   1.130000 (  1.127846)
# StrongJSON:enum        5.560000   0.000000   5.560000 (  5.564537)
# MightyJSON:enum        2.920000   0.000000   2.920000 (  2.913830)
# StrongJSON:optional    2.080000   0.000000   2.080000 (  2.081410)
# MightyJSON:optional    0.180000   0.000000   0.180000 (  0.185282)
# 
# Environment:
#   - StrongJSON: v0.4.0
#   - MightyJSON: 7c4c34fff3e24a9573bc8397985d4080eee87359
#   - Ruby 2.4.1
#   - Arch Linux
#   - Core i7-6700K

require 'mighty_json'
require 'strong_json'
require 'benchmark'

s = StrongJSON.new do
  let :obj, object(a: string, b: number)
  let :str, string
  let :arr, array(string)
  let :enm, enum(string, number)
  let :opt, string?
end

m = MightyJSON.new do
  let :obj, object(a: string, b: number)
  let :str, string
  let :arr, array(string)
  let :enm, enum(string, number)
  let :opt, string?
end


Benchmark.bm(20) do |x|
  x.report('StrongJSON:object')  {2000000.times{s.obj.coerce({a: 'foo', b: 42})}}
  x.report('MightyJSON:object')  {2000000.times{m.obj.coerce({a: 'foo', b: 42})}}

  x.report('StrongJSON:string')  {5000000.times{s.str.coerce('foo')}}
  x.report('MightyJSON:string')  {5000000.times{m.str.coerce('foo')}}

  x.report('StrongJSON:array')   {2000000.times{s.arr.coerce(['foo', 'bar'])}}
  x.report('MightyJSON:array')   {2000000.times{m.arr.coerce(['foo', 'bar'])}}

  x.report('StrongJSON:enum')    {2000000.times{s.enm.coerce(1)}}
  x.report('MightyJSON:enum')    {2000000.times{m.enm.coerce(1)}}

  x.report('StrongJSON:optional'){2000000.times{s.enm.coerce('foo')}}
  x.report('MightyJSON:optional'){2000000.times{m.enm.coerce('foo')}}
end
