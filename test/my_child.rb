class MyChild
  def say_hello
    'Hello'
  end
end

export(MyChild) if defined?(export)
