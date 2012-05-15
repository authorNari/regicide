require "vmmagic/vmmagic-stub"

module Regicide
  @@os = nil

  module_function
  def os
    return @@os if @@os

    os_name = java.lang.System.getProperty('os.arch') + 
      java.lang.System.getProperty('os.name')
    case os_name
    when "amd64Linux"
      require "regicide/os/amd64_linux"
      @@os = OS::Amd64Linux
    else
      raise "#{os_name} is not supported..."
    end
    return @@os
  end
end
