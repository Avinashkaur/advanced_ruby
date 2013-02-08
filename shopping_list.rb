class ShoppingList
  def initialize
    @list = []
  end
  def items(&block)
    instance_eval(&block)
  end
  def add(name, quantity)
    @list << "#{name} :#{quantity} \n"
  end
  def show
    @list.join
  end
end
s1 = ShoppingList.new
ans = 'y'
while ans =~ /[y]/i
  puts "enter item name"
  item_name = gets.chomp
  puts "quantity?"
  quantity = gets.chomp
  s1.items { add(item_name, quantity) }
  puts "Enter more? (y/n)"
  ans = gets.chomp
end
puts "Your Shopping List--"
puts s1.show