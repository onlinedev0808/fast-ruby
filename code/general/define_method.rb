require 'benchmark/ips'

def method_names(number)
  number.times.map do
    10.times.inject("") { |e| e << ('a'..'z').to_a.sample}
  end
end

methods = method_names(10)

def slow
  SampleClassB.def_methods(methods)
end

def fast
  SampleClassA.def_methods(methods)
end

class SampleClassA
  def self.def_methods(methods)
    methods.each do |method_name|
      define_method method_name do
        puts "win"
      end
    end
  end
end

class SampleClassB
  def self.def_methods(methods)
    methods.each do |method_name|
      module_eval %{
        def #{method_name}
          puts "win"
        end
      }
    end
  end
end


Benchmark.ips do |x|
  x.report("module_eval with string") {fast}
  x.report("define_method") {slow}
  x.compare!
end