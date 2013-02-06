class Calculator
  def calculate(operand1, operator, operand2)
    puts eval(operand1.to_s + operator.to_s + operand2.to_s)
  end
end
Calculator.new.calculate(2,:+,3)
Calculator.new.calculate(3,:*,8)