public class FlowSensitivityDemo {

  // Propagator with a "safe mode" switch:
  // - true  => overwrite with a hardcoded safe constant (sanitization)
  // - false => return tainted as-is (bypass)
  static String propagator(String tainted, boolean isSafeMode) {
    String out;
    if (isSafeMode) {
      out = "SAFE_CONSTANT";
    } else {
      out = tainted;
    }
    return out;
  }

  static void test(String userInput) {
    // Call site A: safe-mode is a constant true
    String a = propagator(userInput, true);
    System.out.println("A=" + a);   // ideally: NOT tainted

    // Call site B: safe-mode is a constant false
    String b = propagator(userInput, false);
    System.out.println("B=" + b);   // should be tainted

    // Call site C: unknown at analysis time (not a constant)
    boolean flag = System.currentTimeMillis() > 0;
    String c = propagator(userInput, flag);
    System.out.println("C=" + c);   // typically: tainted (possible bypass)
  }

  public static void main(String[] args) {
    String x = args.length > 0 ? args[0] : "default";
    test(x);
  }
}

