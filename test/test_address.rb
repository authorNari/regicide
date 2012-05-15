class TestAddress < Test::Unit::TestCase
  import org.vmmagic.unboxed

  def setup
    @stat = Regicide::Statistics.new
    @zero = Address.zero
  end

  def test_zero
    assert_equal 0, Address.zero.to_long
    assert_equal 0, Address.zero.to_int
    assert_equal true, Address.zero.zero?
    assert_equal true, Address.zero.zero?
  end

  def test_one
    assert_equal 1, Word.one.to_int
  end

  def test_from_xx
    assert_equal -1, Address.from_int_sign_extend(-1).to_long
    assert_equal 4294967295, Address.from_int_zero_extend(-1).to_long
    assert_equal 0xA0000000, Regicide::OS::Sys.int2ulong(0xA0000000)
  end

  def test_to_xx
    assert_kind_of ObjectReference, @zero.to_object_reference
    assert_kind_of Word, @zero.to_word
  end

  def test_calc
    assert_equal 10, Address.zero.plus(10).to_int
    assert_equal(
      10, Address.zero.plus(Offset.from_int_sign_extend(10)).to_int)
    assert_equal(
      10, Address.zero.plus(Extent.from_int_sign_extend(10)).to_int)
    assert_equal -10, Address.zero.minus(10).to_int
    assert_equal(
      Offset.new(ArchitecturalWord.new(-10)).to_int,
      Address.zero.diff(Address.new(ArchitecturalWord.new(10))).to_int)
  end

  def test_compare
    assert_equal true, Address.zero.LT(Address.from_long(10))
    assert_equal true, Address.zero.LE(Address.from_long(0))
    assert_equal(false,
      Address.fromIntZeroExtend(0x10000000).GE(
        Address.fromLong(0xA0000000)))
    assert_equal -2, Word.one.not.to_int
  end

  def test_read_write
    ptr = Regicide::OS::Amd64Linux::LibC.malloc(100)
    addr = Address.from_long(ptr.address)
    addr.java_send :store, [Java::byte], 10
    assert_equal 10, addr.load_byte
    addr.java_send :store, [Java::char], 10
    assert_equal 10, addr.load_char
    addr.java_send :store, [Java::short], 10
    assert_equal 10, addr.load_short
    addr.java_send :store, [Java::float], 10.0
    assert_equal 10.0, addr.load_float
    addr.java_send :store, [Java::int], 10
    assert_equal 10, addr.load_int
    addr.java_send :store, [Java::long], 0xffffffffffff
    assert_equal 0xffffffffffff, addr.load_long
    addr.store(Word.from_long(0xffffffffffff))
    assert_equal 0xffffffffffff, addr.load_word.to_long
  end
end
