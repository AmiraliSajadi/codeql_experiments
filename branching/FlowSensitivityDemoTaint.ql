/**
 * @name Flow-sensitivity demo: parameter -> System.out.println
 * @id amirali/flow-sensitivity-demo/param-to-println
 * @description Demo taint query to inspect whether call sites/branches lead to distinct path explanations.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @tags experimental
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

class DemoConfig extends TaintTracking::Configuration {
  DemoConfig() { this = "FlowSensitivityDemoTaint" }

  override predicate isSource(DataFlow::Node src) {
    exists(Method m |
      m.getDeclaringType().hasName("FlowSensitivityDemo") and
      m.hasName("test") and
      src.asParameter() = m.getParameter(0)
    )
  }

  override predicate isSink(DataFlow::Node snk) {
    exists(MethodAccess call |
      call.getMethod().hasName("println") and
      call.getMethod().getDeclaringType().hasQualifiedName("java.io", "PrintStream") and
      // the value printed is the sink
      snk.asExpr() = call.getArgument(0)
    )
  }
}

from DemoConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Tainted flow from test(userInput) to println."

