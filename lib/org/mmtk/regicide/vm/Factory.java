package org.mmtk.regicide.vm;

import org.mmtk.regicide.Regicide;
import org.mmtk.utility.gcspy.Color;
import org.mmtk.utility.gcspy.drivers.AbstractDriver;
import org.mmtk.vm.ActivePlan;
import org.mmtk.vm.Assert;
import org.mmtk.vm.Barriers;
import org.mmtk.vm.BuildTimeConfig;
import org.mmtk.vm.Collection;
import org.mmtk.vm.Debug;
import org.mmtk.vm.FinalizableProcessor;
import org.mmtk.vm.Lock;
import org.mmtk.vm.MMTk_Events;
import org.mmtk.vm.Memory;
import org.mmtk.vm.Monitor;
import org.mmtk.vm.ObjectModel;
import org.mmtk.vm.ReferenceProcessor;
import org.mmtk.vm.ReferenceProcessor.Semantics;
import org.mmtk.vm.Scanning;
import org.mmtk.vm.Statistics;
import org.mmtk.vm.Strings;
import org.mmtk.vm.SynchronizedCounter;
import org.mmtk.vm.TraceInterface;
import org.mmtk.vm.gcspy.ByteStream;
import org.mmtk.vm.gcspy.IntStream;
import org.mmtk.vm.gcspy.ServerInterpreter;
import org.mmtk.vm.gcspy.ServerSpace;
import org.mmtk.vm.gcspy.ShortStream;
import org.mmtk.vm.gcspy.Util;
import org.vmutil.options.OptionSet;

public class Factory extends org.mmtk.vm.Factory {

	@Override
	public ActivePlan newActivePlan() {
		return (ActivePlan)Regicide.j("Regicide::ActivePlan.new");
	}

	@Override
	public Assert newAssert() {
		return (Assert)Regicide.j("Regicide::Assert.new");
	}

	@Override
	public Barriers newBarriers() {
		return (Barriers)Regicide.j("Regicide::Barriers.new");
	}

	@Override
	public BuildTimeConfig newBuildTimeConfig() {
		return (BuildTimeConfig)Regicide.j("Regicide::BuildTimeConfig.new");
	}

	@Override
	public Collection newCollection() {
		return (Collection)Regicide.j("Regicide::Collection.new");
	}

	@Override
	public Debug newDebug() {
		return (Debug)Regicide.j("Regicide::Debug.new");
	}

	@Override
	public MMTk_Events newEvents() {
		return (MMTk_Events)Regicide.j("Regicide::MMTkEvents.new");
	}

	@Override
	public FinalizableProcessor newFinalizableProcessor() {
		return (FinalizableProcessor)Regicide.j("Regicide::FinalizableProcessor.new");
	}

	@Override
	public ByteStream newGCspyByteStream(AbstractDriver arg0, String arg1,
			byte arg2, byte arg3, byte arg4, byte arg5, String arg6,
			String arg7, int arg8, int arg9, int arg10, Color arg11,
			boolean arg12) {
		Regicide.j("Regicide::Assert.not_implemented");
		return null;
	}

	@Override
	public IntStream newGCspyIntStream(AbstractDriver arg0, String arg1,
			int arg2, int arg3, int arg4, int arg5, String arg6, String arg7,
			int arg8, int arg9, int arg10, Color arg11, boolean arg12) {
		Regicide.j("Regicide::Assert.not_implemented");
		return null;
	}

	@Override
	public ServerInterpreter newGCspyServerInterpreter() {
		Regicide.j("Regicide::Assert.not_implemented");
		return null;
	}

	@Override
	public ServerSpace newGCspyServerSpace(ServerInterpreter arg0, String arg1,
			String arg2, String arg3, String arg4, int arg5, String arg6,
			boolean arg7) {
		Regicide.j("Regicide::Assert.not_implemented");
		return null;
	}

	@Override
	public ShortStream newGCspyShortStream(AbstractDriver arg0, String arg1,
			short arg2, short arg3, short arg4, short arg5, String arg6,
			String arg7, int arg8, int arg9, int arg10, Color arg11,
			boolean arg12) {
		Regicide.j("Regicide::Assert.not_implemented");
		return null;
	}

	@Override
	public Util newGCspyUtil() {
		Regicide.j("Regicide::Assert.not_implemented");
		return null;
	}

	@Override
	public Lock newLock(String arg0) {
		Object l = Regicide.j("Regicide::Scheduler::Lock");
		return Regicide.JRUBY.callMethod(l, "new", arg0, Lock.class);
	}

	@Override
	public Memory newMemory() {
		return (Memory) Regicide.j("Regicide::Memory.new");
	}

	@Override
	public Monitor newMonitor(String arg0) {
		Object m = Regicide.j("Regicide::Scheduler::Monitor");
		return Regicide.JRUBY.callMethod(m, "new", arg0, Monitor.class);
	}

	@Override
	public ObjectModel newObjectModel() {
		Regicide.j("require \"regicide/object_model\"");
		return (ObjectModel) Regicide.j("Regicide::ObjectModel.new");
	}

	@Override
	public ReferenceProcessor newReferenceProcessor(Semantics arg0) {
		return (ReferenceProcessor) Regicide.j("Regicide::ReferenceProcessor.new");
	}

	@Override
	public Scanning newScanning() {
		Regicide.j("require \"regicide/scanning\"");
		return (Scanning) Regicide.j("Regicide::Scanning.new");
	}

	@Override
	public Statistics newStatistics() {
		return (Statistics) Regicide.j("Regicide::Statistics.new");
	}

	@Override
	public Strings newStrings() {
		return (Strings) Regicide.j("Regicide::Strings.new");
	}

	@Override
	public SynchronizedCounter newSynchronizedCounter() {
		return (SynchronizedCounter) Regicide.j("Regicide::SynchronizedCounter.new");
	}

	@Override
	public TraceInterface newTraceInterface() {
		// not supported.
		return null;
	}

	@Override
	public OptionSet getOptionSet() {
		return (OptionSet) Regicide.j("Regicide::OptionSet.instance");
	}
}
