class MyChild
  def say_hello
    'hello'
  end
end

export(MyChild) if defined?(export)
