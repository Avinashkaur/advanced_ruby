$methods_scope = {}
module MyModule
  module ClassMethods
    def chained_aliasing(fname, lname)
      user_label = 'public'
      $methods_scope.each_pair do |key, value|
        user_label = key.intern if (value == fname) 
        original_method, original_method_with, original_method_without = function_name(fname, lname)
        
        # define_method(original_method_without) do
        #   send (original_method)
        # end
        # define_method(original_method_with) do
        #   puts "--logging start"
        #   send (original_method)      
        #   puts "--logging end"
        # end
        body = %{
          #{user_label}
          def #{original_method_without}
            send #{original_method}
          end
          def #{original_method_with}
            puts "--logging start"
            send #{original_method}      
            puts "--logging end"
          end
        }
        # puts self
        puts body
        self.class_eval body
      end
    end
  end
  def self.included(klass)
    klass.extend ClassMethods
    $methods_scope['public'] = klass.public_instance_methods(false)
    $methods_scope['private'] = klass.private_instance_methods(false)
    $methods_scope['protected'] = klass.protected_instance_methods(false)
    puts $methods_scope
  end
end

def function_name(fname, lname)
  check = fname.to_s.match(/[!|?]/)
  original_method = "#{fname}"
  original_method_with = "#{fname}_with_#{lname}"
  original_method_without = "#{fname}_without_#{lname}"
  if !(check.nil?)
    temp = fname.to_s.gsub(check[0],"")
    original_method_with = "#{temp}_with_#{lname}#{check[0]}"
    original_method_without = "#{temp}_without_#{lname}#{check[0]}"
  end
  return original_method, original_method_with, original_method_without
end
class Hello
  
  def greet
    puts "hello"
  end
  def correct?
    puts "correct"
  end
  private
  def secret
    puts "secret"
  end
  public
  include MyModule
  chained_aliasing :greet, :logger
  chained_aliasing :correct?, :logger
  chained_aliasing :secret, :logger
end
say = Hello.new
say.greet_with_logger
# say.greet_without_logger

# say.correct_with_logger?
# say.correct_without_logger?

# say.secret_with_logger
# say.secret