$object_array = []
def create_new_class(filename)
  klass = filename.split(".").first.capitalize
  $FILEREADER = File.new(filename)
  $method_array_names = ($FILEREADER.gets.chomp!).split(',')
  Object::const_set(klass.to_sym, Class.new do
    $method_array_names.each { |element| attr_accessor element.to_sym }
  end)
end
def create_object_array( klass )  
  while line = $FILEREADER.gets do 
    object = klass.new
    records = line.split(",").each { |element| element.strip! }
    ($method_array_names.size).times do |i|
      object.send "#{$method_array_names[i]}=", records[i]
    end
    $object_array << object
  end
  display_object_array(klass)
end
def display_object_array(klass)
  $object_array.each do |object|
    $method_array_names.each { |meth| puts "#{object.send meth}" }
  end
end
puts "enter file name : trial.csv or emp.csv or emp1.csv"
klass = create_new_class(gets.chomp)
create_object_array(klass)