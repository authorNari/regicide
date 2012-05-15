require "regicide/strings"

class TestStrings < Test::Unit::TestCase
  def setup
    @strings = Regicide::Strings.new
  end

  def test_write
    str = "test"
    mock($stderr).puts(str).once
    @strings.write(str.unpack('c*').to_java(Java::char), str.size)
  end

  def test_write_thread_id
    str = "test"
    mock($stderr).puts("#{Thread.current.object_id}:#{str}").once
    @strings.write_thread_id(str.unpack('c*').to_java(Java::char), str.size)
  end

  def test_copy_string_to_chars
    str = "test"
    dst = [0, 0, 0, 0].to_java(Java::char)
    @strings.copy_string_to_chars(java.lang.String.new(str), dst, 0, dst.size)
    assert_equal "test", java.lang.String.new(dst, 0, dst.size).to_s
  end
end
