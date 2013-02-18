class NewClass < String
  def initialize(name)
    super(name)
  end
  def exclude?
    puts "Enter the value:"
    value = gets.chomp
    puts "Is the value not found in the string entered? #{!self.include?(value)} "
  end
  def to_uppercase
    puts self.upcase
  end
  def no_of_vowels
    count = 0
    self.gsub(/[aeiou]/i) { |character| count += 1 }
    puts "No. of vowels #{count}"
  end 
end
puts "Create the object of the class NewClass in the format: <variable> = NewClass.new('<any-string>')"
element =  gets
puts "Select a method to call from the following in the format element.<methodName> :"
puts "1.exclude? 2.to_uppercase 3.no_of_vowels"
element += gets
eval(element)