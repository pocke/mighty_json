# frozen_string_literal: true

class Variable
  def initialize
    @count = 0
  end

  def next
    @count += 1
    cur
  end

  def cur
    "var#{@count}"
  end

  alias branch dup
end
