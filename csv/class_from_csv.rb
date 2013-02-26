$method_array_name = []
$object_array = []
def get_methods(filename)
  File.open(filename) do |file|  
    file.each_line.first.chomp
  end
end
def create_new_class(klass, filename)
  method_array = get_methods(filename)
  method_array.split(",").each do |method_name|
    $method_array_name << method_name
  end
  Object::const_set(klass.to_sym, Class.new do
    $method_array_name.each do |element|
      attr_accessor element.to_sym
    end
  end)
end
def create_object_array(filename, klass)
  File.open(filename, "r") do |file|  
    file.each_line do |line|
      method_names = get_methods(filename)
      if !(line.match(method_names))
        object = klass.new
        records = line.split(",").each { |element| element.strip! }
        for i in 0..($method_array_name.size-1)
          object.send "#{$method_array_name[i]}=", records[i]
        end
        $object_array << object
      end
    end
  end
end
def display_object_array(klass)
  $object_array.each do |object|
    $method_array_name.each do |meth|
      puts "#{object.send meth}"
    end
  end
end
puts "enter file name : trial.csv or emp.csv or emp1.csv"
name = gets.chomp
classname = name.to_s.split(".").first.capitalize
klass = create_new_class(classname, name)
create_object_array(name, klass)
display_object_array(klass)