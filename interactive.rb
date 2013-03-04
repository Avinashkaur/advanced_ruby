expr = ""
loop do
  # $/ = "\n"
  expr += gets
  begin 
    if expr =~ /^[\s]*$\n/ 
      puts eval(expr)
      expr = ""
    end
    exit(0) if expr =~ /^q$/i
  rescue
    puts "Error!!..Enter again"
    expr = ""
    next
  end
end