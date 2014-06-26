# encoding: UTF-8

require File.join(".", "lib", "cargo")

setup do
  unless defined?(Foo1)
    Foo1 = import("test/foo-1.0.0")
  end

  unless defined?(Foo2)
    Foo2 = import("test/foo-2.0.0")
  end
end

test "Foo is not available" do
  assert nil == defined?(Foo)
end

test "Foo1 is a class" do
  assert Class == Foo1.class
end

test "methods are available" do
  assert "Hello" == Foo1.new.bar
end

test "methods on nested classes are available" do
  assert "Hello" == Foo1::Bar.new.baz
  assert "Hello" == Foo1::Bar::Baz.new.qux
end

test "nested classes are not available in the top level" do
  begin
    Bar::Baz.new.qux
  rescue
    assert NameError == $!.class
  end
end

test "Foo2 should be possible" do
  assert "Hello" == Foo2.new.bar
end

test "Doesn't load files twice" do
  import("test/sets_global")
  assert 1 == import("test/sets_global")
end
