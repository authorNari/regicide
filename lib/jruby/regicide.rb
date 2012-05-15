require "rubygems"
require "java"
#require "MMTk/mmtk.jar"
require "options/options"
require "vmmagic/vmmagic-stub"
require "regicide/os"
require "regicide/os/architectural_word"

module Regicide
  import org.vmmagic.unboxed.Address
  import org.vmmagic.unboxed.Offset
  import org.vmmagic.unboxed.ObjectReference
  import org.vmmagic.unboxed.Extent
  import org.vmmagic.unboxed.Word
end

require "regicide/option_set"
require "regicide/finalizable_processor"
require "regicide/active_plan"
require "regicide/memory"
require "regicide/scheduler"
require "regicide/assert"
require "regicide/barriers"
require "regicide/build_time_config"
require "regicide/collection"
require "regicide/debug"
require "regicide/mmtk_events"
require "regicide/reference_processor"
require "regicide/statistics"
require "regicide/strings"
require "regicide/vm"
