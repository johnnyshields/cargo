Billy = import('test/my_child')

class MyParent

  def child
    @child ||= Billy.new
  end

  def ask_child
    child.say_hello
  end
end

export(MyParent) if defined?(export)
