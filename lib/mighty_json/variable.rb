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
end
