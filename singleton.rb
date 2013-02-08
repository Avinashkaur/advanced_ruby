class String
  def say_hello
    puts "Error: Undefined Method!!"
  end
  class<<self
    def say_hello
      puts "Class method for #{self}"
    end
  end
end

name = "av"
def name.say_hello
  puts "Hello #{self}"
end
name.say_hello
"simran".say_hello #any other instance
String.say_hello #calling class method