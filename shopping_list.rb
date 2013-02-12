class ShoppingList
  def initialize
    @list = {}
  end
  def items(&block)
    instance_eval(&block)
  end
  def add(name, quantity)
    # @list << "#{name} :#{quantity} \n"
    if @list.has_key?(name)
      @list[name] = quantity
    else
      @list[name] = quantity
    end
  end
  def show
    puts "#{name}--#{quantity}"
  end
end
s1 = ShoppingList.new
s1.items do 
  add("toothpaste", 2)
  add("cold cream", 3)
  add("biscuits", 6)
  add("shirt", 2)
end
puts "Your Shopping List-->"
# puts s1.show
s1.show