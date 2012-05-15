class TestLock < Test::Unit::TestCase
  def test_lock
    assert_kind_of(
      org.mmtk.vm.Lock,
      Regicide::Scheduler::Lock.new("Map Lock"))
    assert_kind_of(
      org.mmtk.vm.Monitor,
      Regicide::Scheduler::Monitor.new("Map Monitor"))
  end
end
