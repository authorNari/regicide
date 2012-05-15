class TestAssert < Test::Unit::TestCase
  def test_assert
    Regicide::Assert.new.java_send(
      :_assert, [Java::boolean, java.lang.String], true, "hoge")
    Regicide::Assert.new.java_send(:_assert, [Java::boolean], true)
  end
end
