require 'thread'

module Cargo
  VERSION = "0.0.3"
  REGISTRY = {}
  SEMAPHORE = Mutex.new

  def import(file)
    SEMAPHORE.synchronize do
      REGISTRY.fetch(file.sub(/\.rb$/, '').freeze) do |name|
        load("#{name}.rb", true)
        REGISTRY[name] = Thread.current[:cargo].tap do
          Thread.current[:cargo] = nil
        end
      end
    end
  end

  def export(cargo)
    Thread.current[:cargo] = cargo
  end
end

extend Cargo
