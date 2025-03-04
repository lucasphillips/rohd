// Copyright (C) 2025 Intel Corporation
// SPDX-License-Identifier: BSD-3-Clause
//
// block_labels.dart
// An example that generates SV blocks.
//
// 2025 March 4
// Author: Curtis Anderson <curtis.anderson@intel.com>

// Though we usually avoid them, for this example,
// allow `print` messages (disable lint):
// ignore_for_file: avoid_print

import 'package:rohd/rohd.dart';

class LabeledBlocks extends Module {
  Logic a;
  Logic b;

  Logic get val => output('val');

  LabeledBlocks(this.a, this.b) {
    a = addInput('a', a);
    b = addInput('b', b);

    addOutput('val', width: 2);

    Combinational([
      If.block([
        Iff(a.eq(0) & b.eq(0), [
          val < 0,
        ]),
        ElseIf(a.eq(1) & b.eq(0), [
          val < 1,
        ]),
        // a = 1, b = 1
        Else([
          val < 0,
        ])
      ]),
      Case(
          [b, a].swizzle(),
          [
            CaseItem(Const(LogicValue.ofString('01')), label: '+37test', [
              val < 1,
            ]),
            CaseItem(Const(LogicValue.ofString('10')), [
              val < 0,
            ]),
          ],
          defaultItem: [
            val < 10,
          ],
          conditionalType: ConditionalType.unique)
    ]);
  }
}

Future<void> main({bool noPrint = false}) async {
  final a = Logic(name: 'a');
  final b = Logic(name: 'b');

  // You could instantiate this module with some code such as:
  final code = LabeledBlocks(a, b);

  // Below will generate an output of the ROHD-generated SystemVerilog:
  await code.build();
  final generatedSystemVerilog = code.generateSynth();
  if (!noPrint) {
    print(generatedSystemVerilog);
  }
}
