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
    for i in 0..($method_array_name.size - 1)
      attr_accessor $method_array_name[i].to_sym
    end
  end
    )
end
def create_object_array(filename, klass)
    File.open(filename, "r") do |file|  
      file.each_line do |line|
        object = klass.new
        records = line.split(",").each { |element| element.strip! }
        for i in 0..($method_array_name.size-1)
          object.send "#{$method_array_name[i]}=", records[i]
        end
        $object_array << object
      end
    end
end

def display_object_array(klass)
  for j in 1..($object_array.size - 1)
    for i in 0..($method_array_name.size-1)
      puts " #{$object_array[0].send $method_array_name[i]}: #{$object_array[j].send $method_array_name[i]}"
    end
  end
end
puts "enter file name : trial.csv or emp.csv or emp1.csv"
name = gets.chomp
classname = name.to_s.split(".").first.capitalize
klass = create_new_class(classname, name)
create_object_array(name, klass)
display_object_array(klass)