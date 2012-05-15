package org.mmtk.regicide;

import org.jruby.embed.PathType;
import org.jruby.embed.ScriptingContainer;

public class Regicide {
	public static final ScriptingContainer JRUBY;
	
	static {
		JRUBY = new ScriptingContainer();
		JRUBY.runScriptlet(PathType.CLASSPATH, "regicide.rb");
	}
	
	/*
	 * evaluate JRuby scripts
	 */
	public static Object j(String script) {
		return JRUBY.runScriptlet(script);
	}
	
	public static void entry(String entry_point, String[] args) {
		Object receiver = JRUBY.runScriptlet(PathType.ABSOLUTE, entry_point);
		if (args.length > 0) {
			JRUBY.callMethod(receiver, "run", args, Object.class);			
		} else {
			JRUBY.callMethod(receiver, "run", Object.class);			
		}
	}
}
