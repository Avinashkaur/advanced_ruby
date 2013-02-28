$object_array = []
ARGS = []
module ObjectStore
  
  module ClassMethods
    
    def validate_presence_of(*args)
      puts "called with #{args}"
      ARGS << args
      # .each do |element|
      #   puts "in presence func"
      #   puts "#{element}" 
      #   puts instance_variable_get("@#{element}")
      # end
    end
    
    def create_method(args_array)
      ghostclass = class<<self; self; end
      ghostclass.instance_eval do
        args_array.each do |arg|
          define_method("find_by_#{arg}") do |value|
            arr = $object_array.select do |object|
              "#{object.fname}, #{object.age}, #{object.email}" if (object.instance_variable_get("@#{arg}") == value)
            end
            arr
          end
        end
      end
    end
    def collect
      puts "Objects: "
      $object_array.each { |obj| puts obj }
    end
    def count
      puts "Total objects: #{$object_array.size}"
    end
  end
  def save
    var_arr = self.instance_variables.select { |ele| ele.to_s.gsub!(/\@/, "") }
    puts "value is #{ARGS.flatten!}"
    # puts "#{ARGS}"
    puts "var_arr: #{var_arr}"
    puts "#{ARGS - var_arr}"
    # if (ARGS - var_arr).empty?
    #   begin
    #     if !validate 
    #       puts "This object cannot be inserted into the array!!"
    #       exit 0
    #     end
    #   rescue
    #     puts "no validation done"
    #   ensure
    #     $object_array << self
    #     arr = instance_variables.select { |ele| ele.to_s.gsub!(/\@/, "")}
    #     Play.create_method(arr)
    #   end
    # end
  end
  def self.included(klass)
    klass.extend ClassMethods
  end
end
class Play
  include ObjectStore
  attr_accessor :age, :fname, :email
  validate_presence_of :fname, :age 
  
  def validate
    return true if ((@age >= 18) && (@age < 30) && (@fname =~ /[a-zA-z]*/) && (@email =~ /^(?:\w+\.?)*\w+@(?:\w+\.?)*\w+$/))
    false
  end
end

p2 = Play.new
p2.fname = "av"
p2.age = 23
p2.email = "avinash.kaur@vinsol.com"
p2.save
puts $object_array
# p3 = Play.new
# p3.fname = "avinash"
# p3.age = 19
# p3.email = "avi.kaur9@gmail.com"
# p3.save

# p4 = Play.new
# p4.fname = "simran"
# p4.age = 23
# p4.email = "sim@gmail.com"
# p4.save
# puts Play.find_by_age(23)
# puts Play.find_by_fname("avinash")
# puts Play.find_by_email("avinash.kaur@vinsol.com")
# Play.collect
# Play.count

# class Clay
#   include ObjectStore
#   attr_accessor :age, :fname, :email
#   validate_presence_of :fname, :age 
# end

# c = Clay.new
# c.fname = "paris"
# c.age = 26
# c.email = "paris.hilton@gmail.com"
# c.save