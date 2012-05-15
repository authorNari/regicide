class TestMemory < Test::Unit::TestCase
  import org.vmmagic.unboxed

  def setup
    @memory = Regicide::Memory.new
  end

  def test_dump_memory
#    @memory.dumpMemory(Address.from_long(0x1000000), 10, 10)
  end
end
