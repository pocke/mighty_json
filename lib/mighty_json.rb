# frozen_string_literal: true

require "mighty_json/version"
require 'mighty_json/errors'
require 'mighty_json/type'
require 'mighty_json/types'
require 'mighty_json/builder'
require 'mighty_json/variable'

module MightyJSON
  def self.new(&block)
    Builder.new(&block).compile💪💪💪
  end
end
