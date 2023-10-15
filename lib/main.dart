import 'package:flutter/material.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String input = "";
  String output = "";

  bool sqrtPressed = false;
  String currentNumber = "";
  bool currentSqrt = false;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        input = "";
        output = "";
        currentNumber = "";
        sqrtPressed = false;
      } else if (buttonText == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(input);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          if (currentSqrt) {
            eval = sqrt(eval);
            currentSqrt = false;
          }

          if (currentNumber == "ln") {
            eval = log(eval);
            currentNumber = "";
          }

          output = eval.toString();
        } catch (e) {
          output = "Error";
        }
      } else if (buttonText == ".") {
        if (!currentNumber.contains(".") && !sqrtPressed) {
          currentNumber += buttonText;
          input += buttonText;
        }
      } else if (buttonText == "+/-") {
        if (input.isNotEmpty) {
          if (input[0] == '-') {
            input = input.substring(1);
          } else {
            input = '-' + input;
          }
        } else {
          input = '-';
        }
      } else if (buttonText == "√") {
        if (!sqrtPressed) {
          sqrtPressed = true;
          currentNumber = "$currentNumber^0.5";
          input = input + "^(0.5)";
        }
      } else if (buttonText == "π") {
        currentNumber = pi.toStringAsFixed(10);
        input += currentNumber;
      } else if (buttonText == "e") {
        currentNumber = e.toStringAsFixed(10); // Agregar el valor de e
        input += currentNumber;
      } else if (buttonText == "^") {
        currentNumber += "^";
        input += "^";
      } else if (buttonText == "ln") {
        currentNumber = "ln";
        input += "ln(";
      } else {
        currentNumber += buttonText;
        input += buttonText;
      }
    });
  }

  Widget buildButton(String buttonText,
      {Color? buttonColor, double fontSize = 30.0}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: buttonColor ?? Color(0xFFADACAC),
            onPrimary: Colors.white,
            padding: EdgeInsets.all(20.0),
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          onPressed: () {
            buttonPressed(buttonText);
          },
          child: Text(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> buttonRows = [
      ["7", "8", "9", "/"],
      ["4", "5", "6", "*"],
      ["1", "2", "3", "-"],
      ["0", ".", "+/-", "+"],
      ["^", "sin", "cos", "tan"],
      ["√", "π", "e", "ln"],
      ["(", ")", "C", "="],
    ];

    List<Row> rows = [];
    for (List<String> row in buttonRows) {
      List<Widget> buttons = [];
      for (String buttonText in row) {
        buttons.add(buildButton(buttonText));
      }
      rows.add(Row(children: buttons));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora científica UPeU"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    input,
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    output,
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1),
            for (var row in rows) row,
          ],
        ),
      ),
    );
  }
}
