require "regicide/synchronized_counter"

class TestSynchronizedCounter < Test::Unit::TestCase
  def setup
    @counter = Regicide::SynchronizedCounter.new
  end

  def test_increment
    assert_equal 1, @counter.increment
  end

  def test_reset
    @counter.increment
    assert_equal 1, @counter.reset
    assert_equal 0, @counter.reset
  end

  def test_peek
    @counter.increment
    assert_equal 1, @counter.peek
  end
end
