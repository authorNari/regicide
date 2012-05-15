package org.vmmagic.unboxed;

import org.mmtk.regicide.Regicide;
import org.vmmagic.pragma.Interruptible;
import org.vmmagic.pragma.RawStorage;
import org.vmmagic.pragma.Uninterruptible;

@RawStorage(lengthInWords = true, length = 1)
@Uninterruptible
public final class ArchitecturalWord {
	public final Object value;
	private static final Object AW;
	
	static {
		AW = Regicide.j("Regicide::OS::ArchitecturalWord");
	}
	
	public ArchitecturalWord() {
		this.value = Regicide.j("Regicide::OS::ArchitecturalWord.new");
	}
	
	public ArchitecturalWord(Object value) {
		this.value = value;
	}
	
	public ArchitecturalWord(int value, boolean zeroExtend) {
		if (zeroExtend) {
			this.value = Regicide.JRUBY.callMethod(AW, "from_int_zero_extend", value, Object.class);
		} else {
			this.value = Regicide.JRUBY.callMethod(AW, "from_long", value, Object.class);
		}
	}

	public ArchitecturalWord(long value) {
		this.value = Regicide.JRUBY.callMethod(AW, "new", value, Object.class);
	}
	
	public boolean equals(ArchitecturalWord value) {
		return Regicide.JRUBY.callMethod(this.value, "==", value.value, java.lang.Boolean.class);
	}
	
	public static ArchitecturalWord max() {
		return new ArchitecturalWord(
				Regicide.j("Regicide::OS::ArchitecturalWord.max"));
	}
	
	public boolean isMax(ArchitecturalWord other) {
		return Regicide.JRUBY.callMethod(this.value, "max?", other.value, java.lang.Boolean.class);
	}
	
	@Override
	@Interruptible
	public String toString() {
		return Regicide.JRUBY.callMethod(this.value, "to_s", String.class);

	}

	@Override
	public int hashCode() {
		return Regicide.JRUBY.callMethod(this.value, "to_i", java.lang.Long.class).intValue();
	}
	
	public int toInt() {
		return Regicide.JRUBY.callMethod(this.value, "to_i", java.lang.Long.class).intValue();
	}
	
	public long toLong() {
		return Regicide.JRUBY.callMethod(this.value, "to_i", java.lang.Long.class);
	}

	public static ArchitecturalWord fromLong(long v) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(AW, "from_long", v, Object.class));
	}

	public long toLongZeroExtend() {
		return Regicide.JRUBY.callMethod(this.value, "to_long_zero_extend", java.lang.Long.class);
	}

	public long toLongSignExtend() {
		return Regicide.JRUBY.callMethod(this.value, "to_i", java.lang.Long.class);
	}

	public ArchitecturalWord plus(int other) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "plus", other, Object.class));
	}

	public ArchitecturalWord plus(long other) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "plus", other, Object.class));
	}

	public ArchitecturalWord minus(long other) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "minus", other, Object.class));
	}

	public static ArchitecturalWord fromIntZeroExtend(int v) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(AW, "from_int_zero_extend", v, Object.class));
	}

	public static ArchitecturalWord fromIntSignExtend(int v) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(AW, "from_long", v, Object.class));
	}

	public boolean LT(ArchitecturalWord other) {
		return Regicide.JRUBY.callMethod(this.value, "<", other.value, java.lang.Boolean.class);
	}

	public boolean LE(ArchitecturalWord other) {
		return Regicide.JRUBY.callMethod(this.value, "<=", other.value, java.lang.Boolean.class);

	}

	public boolean GT(ArchitecturalWord other) {
		return Regicide.JRUBY.callMethod(this.value, ">", other.value, java.lang.Boolean.class);
	}

	public boolean GE(ArchitecturalWord other) {
		return Regicide.JRUBY.callMethod(this.value, ">=", other.value, java.lang.Boolean.class);
	}

	public boolean EQ(ArchitecturalWord other) {
		return Regicide.JRUBY.callMethod(this.value, "==", other.value, java.lang.Boolean.class);
	}

	public boolean NE(ArchitecturalWord other) {
		return Regicide.JRUBY.callMethod(this.value, "!=", other.value, java.lang.Boolean.class);
	}

	public boolean isZero() {
		return Regicide.JRUBY.callMethod(this.value, "zero?", java.lang.Boolean.class);
	}

	public ArchitecturalWord rshl(int amt) {
		long v = Regicide.JRUBY.callMethod(this.value, "to_i", java.lang.Long.class);
		v = v >>> amt;
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(AW, "new", v, Object.class));
	}

	public ArchitecturalWord rsha(int amt) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "rsha", amt, Object.class));
	}

	public ArchitecturalWord lsh(int amt) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "lsh", amt, Object.class));
	}

	public final boolean sLE(ArchitecturalWord word) {
		return sLT(word) || EQ(word);
	}

	public final boolean sGT(ArchitecturalWord word) {
		return !sLE(word);
	}

	public final boolean sGE(ArchitecturalWord word) {
		return !sLT(word);
	}

	public boolean sLT(ArchitecturalWord other) {
		return Regicide.JRUBY.callMethod(this.value, "<", other.value, java.lang.Boolean.class);
	}

	public boolean isMax() {
		return Regicide.JRUBY.callMethod(this.value, "max?", java.lang.Boolean.class);
	}

	public ArchitecturalWord and(ArchitecturalWord other) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "and", other.value, Object.class));
	}

	public ArchitecturalWord or(ArchitecturalWord other) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "or", other.value, Object.class));
	}

	public ArchitecturalWord xor(ArchitecturalWord other) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "xor", other.value, Object.class));
	}

	public ArchitecturalWord not() {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "not", Object.class));
	}

	public static ArchitecturalWord zero() {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(AW, "zero", Object.class));
	}

	public ArchitecturalWord diff(ArchitecturalWord other) {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "diff", other.value, Object.class));
	}

	public byte getByte() {
		return Regicide.JRUBY.callMethod(this.value, "read_byte", java.lang.Byte.class);
	}

	public char getChar() {
		return Regicide.JRUBY.callMethod(this.value, "read_char", java.lang.Character.class);
	}

	public short getShort() {
		return Regicide.JRUBY.callMethod(this.value, "read_short", java.lang.Short.class);
	}

	public float getFloat() {
		return Regicide.JRUBY.callMethod(this.value, "read_float", java.lang.Float.class);
	}

	public int getInt() {
		return Regicide.JRUBY.callMethod(this.value, "read_int", java.lang.Integer.class);
	}

	public long getLong() {
		return Regicide.JRUBY.callMethod(this.value, "read_long", java.lang.Long.class);
	}

	public double getDouble() {
		return Regicide.JRUBY.callMethod(this.value, "read_double", java.lang.Double.class);
	}

	public ArchitecturalWord getWord() {
		return new ArchitecturalWord(
				Regicide.JRUBY.callMethod(this.value, "read_word", Object.class));
	}

	public void setWord(ArchitecturalWord val) {
		Regicide.JRUBY.callMethod(this.value, "write_word", val.value, null);
	}

	public void setByte(byte val) {
		Regicide.JRUBY.callMethod(this.value, "write_byte", val, null);
	}

	public void setInt(int val) {
		Regicide.JRUBY.callMethod(this.value, "write_int", val, null);
	}

	public void setDouble(double val) {
		Regicide.JRUBY.callMethod(this.value, "write_double", val, null);
	}

	public void setLong(long val) {
		Regicide.JRUBY.callMethod(this.value, "write_long", val, null);
	}

	public void setChar(char val) {
		Regicide.JRUBY.callMethod(this.value, "write_char", val, null);
	}

	public void setFloat(float val) {
		Regicide.JRUBY.callMethod(this.value, "write_float", val, null);
	}

	public void setShort(short val) {
		Regicide.JRUBY.callMethod(this.value, "write_short", val, null);
	}

	public boolean exchangeInt(int old, int val) {
		// TODO: use CAS
		Regicide.JRUBY.callMethod(this.value, "write_int", val, null);
		return true;
	}

	public boolean exchangeLong(long old, long val) {
		// TODO: use CAS
		Regicide.JRUBY.callMethod(this.value, "write_long", val, null);
		return true;
	}

	public boolean exchangeWord(ArchitecturalWord old, ArchitecturalWord val) {
		// TODO: use CAS
		Regicide.JRUBY.callMethod(this.value, "write_word", val.value, null);
		return true;
	}

}

