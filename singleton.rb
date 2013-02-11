class String
  def say_hello
    puts "Error: Undefined Method!!"
  end
end
name = "av"
def name.say_hello
  puts "Hello #{self}"
end
class<<name
  def say_hello
    puts "Class method for #{self}"
  end
end
name.say_hello
"simran".say_hello #any other instance