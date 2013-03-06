$target_methods_before_filter, $target_methods_after_filter = [], []
$before_filter_methods, $after_filter_methods = [], []
module FilterModule
  module ClassMethods
    METHOD_HASH = Hash.new

    def new
      filter_method
      super
    end

    def before_filter(*args)
      $before_filter_methods = args
    end 
    def after_filter(*args)
      $after_filter_methods = args
    end
    def prepare_for_filter
      $before_filter_methods, $target_methods_before_filter = get_methods($before_filter_methods)
      $after_filter_methods, $target_methods_after_filter = get_methods($after_filter_methods)
    end

    def get_methods(args_array)
      target_method_array = public_instance_methods(false)
      filter_methods = []
      target_method_array.each do |meth|
        METHOD_HASH[meth] = instance_method(meth)
      end
      args_array.each do |meth|
        if meth.class == Hash
          target_method_array = meth.values_at(:only) if meth.has_key?(:only)
          target_method_array -= meth.values_at(:except).flatten if meth.has_key?(:except)
        else
          filter_methods.push(meth)
        end 
      end
      return filter_methods, target_method_array
    end

    def filter_method
      prepare_for_filter
      $target_methods_before_filter.flatten.each do |meth|
        original_method = instance_method(meth.to_sym)
        define_method(meth) do
          $before_filter_methods.each do |m| 
            METHOD_HASH[m].bind(self).call unless (m == meth)
          end
          original_method.bind(self).call
        end
      end
      $target_methods_after_filter.flatten.each do |meth|
        original_method = instance_method(meth.to_sym)
        define_method(meth) do
          original_method.bind(self).call
          $after_filter_methods.each do |m| 
            METHOD_HASH[m].bind(self).call unless (m == meth)
          end
        end
      end
    end
  end

  def self.included(klass)
    klass.extend ClassMethods
  end
end
class MyClass
  include FilterModule
  before_filter :greet, :only=>[:sleep]
  after_filter :say, :bye, :except=>[:hello]  
  def say
    puts "say method"
  end
  def sleep
    puts "sleep method"
  end
  def greet
    puts "greet method"
  end
  def bye
    puts "bye method"
  end
  def hello
    puts "hello method"
  end

end

obj = MyClass.new
obj.hello
puts
obj.say
puts 
obj.sleep