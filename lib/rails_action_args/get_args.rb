if Method.instance_methods.include?(:parameters)
  require File.join(File.dirname(__FILE__), "native")
elsif RUBY_PLATFORM == "java"
  require File.join(File.dirname(__FILE__), "jruby_args")
elsif RUBY_VERSION < "1.9"
  require File.join(File.dirname(__FILE__), "mri_args")
else
  require File.join(File.dirname(__FILE__), "vm_args")
end
 
class UnboundMethod
  include GetArgs
end
 
class Method
  include GetArgs
end