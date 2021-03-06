$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require File.join("lib", "cargo")
require 'minitest/autorun'

class CargoTest < Minitest::Test

  # Foo1 = import("test/foo-1.0.0")
  # Foo2 = import("test/foo-2.0.0")

  def setup
    unless defined?(Foo1)
      self.class.const_set 'Foo1', import("test/foo-1.0.0")
    end

    unless defined?(Foo2)
      self.class.const_set 'Foo2', import("test/foo-2.0.0")
    end
  end

  def test_Foo_is_not_available
    assert_equal nil, defined?(Foo)
  end

  def test_Foo1_is_a_class
    assert_equal Class, Foo1.class
  end

  def test_methods_are_available
    assert_equal "Hello", Foo1.new.bar
  end

  def test_methods_on_nested_classes_are_available
    assert_equal "Hello", Foo1::Bar.new.baz
    assert_equal "Hello", Foo1::Bar::Baz.new.qux
  end

  def test_nested_classes_are_not_available_in_the_top_level
    begin
      Bar::Baz.new.qux
    rescue
      assert_equal NameError, $!.class
    end
  end

  def test_Foo2_should_be_possible
    assert_equal "Hello", Foo2.new.bar
  end

  def test_doesnt_load_files_twice
    import("test/sets_global")
    assert_equal 1, import("test/sets_global")
  end

  def test_nested_imports
    parent = import("test/my_parent")
    assert_match /^#<Module:0x[0-9a-z]{14}>::MyChild$/, parent.new.child.class.name
    assert_match 'Hello', parent.new.ask_child
  end
end
