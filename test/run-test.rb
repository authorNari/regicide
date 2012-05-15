#!/usr/bin/env jruby

require "java"
base_dir = File.expand_path(File.dirname(__FILE__))
top_dir = File.expand_path(File.join(base_dir, ".."))
$CLASSPATH << File.expand_path("ext/jikesrvm", top_dir)
$CLASSPATH << File.expand_path("lib/jruby", top_dir)
$CLASSPATH << File.expand_path("build.eclipse", top_dir)
$CLASSPATH << "/home/nari/source/jikesrvm-3.1.2/eclipse/bin/"
java.lang.System.set_property("mmtk.hostjvm",
                              "org.mmtk.regicide.vm.Factory")

require "rubygems"
org.mmtk.regicide.Regicide.j("puts 'loading regicide to script container...'")
require "regicide"
require "test-unit"
require "test/unit/rr"
require "rr"

test_file = "./test/test_*.rb"
Dir.glob(test_file) do |file|
  require file
end
