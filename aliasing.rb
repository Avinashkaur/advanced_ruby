module MyModule

  module ClassMethods
    def chained_aliasing(fname, lname)
      user_label = ''
      const_get(:Methods_scope).each_pair do |key, value|
        user_label = key if value.include?(fname)
      end
      original_method, original_method_with, original_method_without = function_name(fname, lname)
      hash = self.const_get(:METHOD_HASH)
      hash[original_method] = instance_method(original_method)
      body = %{
        #{user_label}
        def #{original_method}
          puts "--logging start"
          self.class.const_get(:METHOD_HASH)['#{original_method}'].bind(self).call
          puts "--logging end"
        end
        def #{original_method_without}
          self.class.const_get(:METHOD_HASH)['#{original_method}'].bind(self).call
        end
        def #{original_method_with}
          puts "--logging start"
          self.class.const_get(:METHOD_HASH)['#{original_method}'].bind(self).call      
          puts "--logging end"
        end
      }
      class_eval body
    end
  end
  
  def self.included(klass)
    klass.extend ClassMethods
    klass.const_set(:METHOD_HASH, {})
    methods_scope = {}
    methods_scope['public'] = klass.public_instance_methods(false)
    methods_scope['private'] = klass.private_instance_methods(false)
    methods_scope['protected'] = klass.protected_instance_methods(false)
    klass.const_set(:Methods_scope, methods_scope)
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
say.greet_without_logger
say.greet
puts
say.correct_with_logger?
say.correct_without_logger?
say.correct?
# say.secret_with_logger