require "regicide/statistics"

class TestStatistics < Test::Unit::TestCase
  def setup
    @stat = Regicide::Statistics.new
  end

  def test_nano_time
    assert_kind_of Integer, @stat.nano_time
  end
end
