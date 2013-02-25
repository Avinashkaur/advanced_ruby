module MyModule
  module ClassMethods
    def chained_aliasing(fname, lname)
      original_method, original_method_with, original_method_without = function_name(fname, lname)
      define_method(original_method_without) do
        send (original_method)
      end
      define_method(original_method_with) do
        puts "--logging start"
        send (original_method)      
        puts "--logging end"
      end
    end
  end

  def self.included(klass)
    klass.extend ClassMethods
  end
end

def function_name(fname, lname)
  check = fname.to_s.match(/[!|?]/)
  puts fname
  if (check.nil?)
    original_method = "#{fname}"
    original_method_with = "#{fname}_with_#{lname}"
    original_method_without = "#{fname}_without_#{lname}"
  else
    temp = fname.to_s.gsub(check[0],"")
    original_method = "#{fname}"
    original_method_with = "#{temp}_with_#{lname}#{check[0]}"
    original_method_without = "#{temp}_without_#{lname}#{check[0]}"
  end
  return original_method, original_method_with, original_method_without
end


class Hello
  include MyModule
  def greet
    puts "hello"
  end
  def correct?
    puts "correct"
  end
  chained_aliasing :greet, :logger
  chained_aliasing :correct?, :logger
end
say = Hello.new
# say.greet
say.greet_with_logger
say.greet_without_logger

say.correct_with_logger?
say.correct_without_logger?