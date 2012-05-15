# -*- coding: utf-8 -*-
require "rubygems"
require "bundler/setup"

task :test do
  puts "You need `jruby --ng-server &`"
  sh "/usr/bin/env jruby --ng -S test/run-test.rb"
end

task :default => :test
