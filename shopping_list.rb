class ShoppingList
  def initialize
    @list = {}
  end
  def items(&block)
    instance_eval(&block)
  end
  def add(name, quantity)
    if @list.has_key?(name)
      @list[name] += quantity
    else
      @list[name] = quantity
    end
  end
  def show
    @list.each_pair do |key,value|
      puts "#{key} : #{value}"
    end  
  end
end
s1 = ShoppingList.new
s1.items do 
  add("toothpaste", 2)
  add("shirt", 9)
  add("biscuits", 6)
  add("shirt", 2)
end
puts "Your Shopping List-->"
s1.show