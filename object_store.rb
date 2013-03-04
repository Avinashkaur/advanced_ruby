$object_array = []
module ObjectStore

  module ClassMethods
    def validate_presence_of(*args)
      @_attributes = (args.map { |attr| "@#{attr}".intern  })
    end
    def method_missing(name, *args)
      if name =~ /^find_by_(.*)$/
        attr_name = $1
        attr_value = args.first
        $object_array.select { |obj| obj.send(attr_name) == attr_value } 
      else
        super
      end
    end
    def collect
      puts "Objects: "
      puts $object_array
    end
    def count
      puts "Total objects: #{$object_array.size}"
    end
  end

  def save
    $object_array << self if object_valid?
  end

  def object_valid?
    @attr_errors = []
    self.class.instance_variable_get(:@_attributes).each do |attr|
      if instance_variables.include?(attr) 
        @attr_errors.push(attr) if instance_variable_get(attr).nil?
      else
        @attr_errors.push(attr) 
      end
    end
    if self.class.method_defined?(:validate)
      @attr_errors.push("validation failed!") unless validate 
    end
    @attr_errors.empty?
  end

  def self.included(klass)
    klass.extend ClassMethods
    klass.instance_variable_set(:@_attributes, [])
  end

end

class Play
  include ObjectStore
  attr_accessor :age, :fname, :email
  validate_presence_of :fname, :age 

  def validate
    true
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

p4 = Play.new
p4.fname = "simran"
p4.age = 23
p4.email = "sim@gmail.com"
p4.save

puts "#{Play.find_by_age(23)}"
puts "#{Play.find_by_fname("avinash")}"
puts "#{Play.find_by_email("avinash.kaur@vinsol.com")}"
Play.collect
Play.count