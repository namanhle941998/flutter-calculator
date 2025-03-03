import 'package:calculator_app/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String userInput = '';
  String latestInput = '';
  String number1 = '';
  String number2 = '';
  String operand = '';
  String result = '';

  late Map btnToAction;

  @override
  void initState() {
    super.initState();
    btnToAction = {
      Btn.calculate: calculateResult,
      Btn.clr: clearInput,
      Btn.n0: addInput,
      Btn.n1: addInput,
      Btn.n2: addInput,
      Btn.n3: addInput,
      Btn.n4: addInput,
      Btn.n5: addInput,
      Btn.n6: addInput,
      Btn.n7: addInput,
      Btn.n8: addInput,
      Btn.n9: addInput,
      Btn.add: addInput,
      Btn.subtract: addInput,
      Btn.multiply: addInput,
      Btn.divide: addInput,
      Btn.dot: addInput,
      Btn.del: deleteLatestInput,
    };
  }

  void handleUserInput(value) {
    setState(() {
      latestInput = value;
    });
    btnToAction.forEach((key, value) {
      if (key == latestInput) {
        value();
      }
    });
  }

  void addInput() {
    setState(() {
      if (result.isNotEmpty) {
        userInput = latestInput;
      } else {
        userInput += latestInput;
      }
    });
  }

  void clearInput() {
    setState(() {
      userInput = '';
      number1 = '';
      number2 = '';
      operand = '';
      result = '';
    });
  }

  void deleteLatestInput() {
    setState(() {
      userInput = userInput.substring(0, userInput.length - 1);
    });
  }

  void refreshInput() {
    setState(() {
      userInput = '';
      number1 = '';
      number2 = '';
      operand = '';
    });
  }

  void extractNumberAndOperand() {
    setState(() {
      for (int i = 0; i < userInput.length; i++) {
        if (userInput[i] == Btn.add ||
            userInput[i] == Btn.subtract ||
            userInput[i] == Btn.multiply ||
            userInput[i] == Btn.divide) {
          operand = userInput[i];
          number1 = userInput.substring(0, i);
          number2 = userInput.substring(i + 1, userInput.length);
          break;
        }
      }
    });
  }

  void calculateResult() {
    setState(() {
      if (!checkValidExpression()) {
        setState(() {
          this.result = 'Invalid Expression';
        });
        refreshInput();
        return;
      }
      extractNumberAndOperand();
      double result = 0;
      switch (operand) {
        case Btn.add:
          result = double.parse(number1) + double.parse(number2);
          break;
        case Btn.subtract:
          result = double.parse(number1) - double.parse(number2);
          break;
        case Btn.multiply:
          result = double.parse(number1) * double.parse(number2);
          break;
        case Btn.divide:
          result = double.parse(number1) / double.parse(number2);
          break;
      }
      setState(() {
        this.result = result.toString();
      });
      refreshInput();
    });
  }

  bool checkValidExpression() {
    List operands = [Btn.add, Btn.subtract, Btn.multiply, Btn.divide, Btn.dot];

    for (int i = 0; i < userInput.length - 1; i++) {
      if (operands.contains(userInput[i]) &&
          operands.contains(userInput[i + 1])) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    result.isNotEmpty
                        ? result
                        : userInput.isEmpty
                        ? '0'
                        : userInput,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // buttons
            Wrap(
              children:
                  Btn.buttonValues
                      .map(
                        (value) => SizedBox(
                          width:
                              value == Btn.n0
                                  ? (screenSize.width / 2)
                                  : (screenSize.width / 4),
                          height: screenSize.width / 5,
                          child: buildButton(value),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        child: InkWell(
          onTap: () => {handleUserInput(value)},
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(value) {
    setState(() {
      userInput += value;
    });
  }

  Color getBtnColor(value) {
    if ([Btn.del, Btn.clr].contains(value)) {
      return Colors.blueGrey;
    } else if ([
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
    ].contains(value)) {
      return Colors.orange;
    } else {
      return Colors.black87;
    }
  }
}
