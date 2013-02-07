class Program
  def self.show_output(name, info)
    define_method("#{name}") do |info|
      puts "\nYou created the following method:"
      puts "\ndef #{name}"
      puts "#{info}"
      puts "end"
    end
  end
end
puts "Enter a method name:"
user_name = gets.chomp
puts "Enter line you wish to write in the method"
user_code = gets.chomp
Program.show_output(user_name, user_code)
Program.new.send("#{user_name}",user_code)