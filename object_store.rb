$object_array = []

module ObjectStore
  module ClassMethods
    def validate_presence_of(*args)
      args_array = args
      args_array.each do |element|
        if (element.size == 0)
          exit(0)
        end
      end
    end
    def create_method(args_array)
      ghostclass = class<<self; self; end
      ghostclass.instance_eval do
        args_array.each do |arg|
          define_method("find_by_#{arg}") do |value|
            $object_array.each do |object|
              if (object.instance_variable_get("@#{arg}") == value)
                p "Found #{value}"
                puts "First Name: #{object.instance_variable_get("@fname")}"
                puts "Age: #{object.instance_variable_get("@age")}"
                puts "Email: #{object.instance_variable_get("@email")}"
              end
            end
          end
        end
      end
    end
  end
  def save
    begin
      if validate 
        $object_array << self
        arr = []
        self.instance_variables.each { |ele| arr << ele.to_s.gsub!(/\@/, "")}
        Play.create_method(arr)
      else
        puts "This object cannot be inserted into the array!!"
      end
    rescue
      p "Module cannot be included!!"
    end
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

p3 = Play.new
p3.fname = "avinash"
p3.age = 19
p3.email = "avi.kaur9@gmail.com"
p3.save
Play.find_by_age(23)
Play.find_by_fname("avinash")
Play.find_by_email("avinash.kaur@vinsol.com")