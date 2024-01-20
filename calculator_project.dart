// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  String textDisplayed = "0";
  bool lastClickIsOperation = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                height: double.infinity,
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    textDisplayed,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: AllButtons(
                onButtonPressed: (String text, bool representsOperation) {
                  _performCalculations(text, representsOperation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performCalculations(String text, bool representsOperation) {
    setState(() {
      if (representsOperation) {
        if (text == "AC") {
          textDisplayed = "0";
          lastClickIsOperation = false;

          // so that lastClickIsOperation doesn't get changed isa.
          return;
        }else if (text == "DEL") {
          if (textDisplayed.length == 1) {
            textDisplayed = "0";
          }else {
            textDisplayed = textDisplayed.substring(0, textDisplayed.length - 1);
          }

          var lastChar = textDisplayed.substring(textDisplayed.length - 1);
          var nonOperationDigits = "0123456789.";
          if (nonOperationDigits.contains(lastChar)) {
            lastClickIsOperation = false;
          }else {
            lastClickIsOperation = true;
          }

          // so that lastClickIsOperation doesn't get changed isa.
          return;
        }else if (lastClickIsOperation) {
          if (text == "=") {
            return;
          }

          var withoutLastOperation = textDisplayed.substring(0, textDisplayed.length - 1);
          textDisplayed = withoutLastOperation + text;
        }else if(text == "=") {
          // todo if 3 + 3 x 3 -> calculates 3 + 3 first which is wrong, so adjust later isa.
          var regexAnyOperationDigit = RegExp("[%/x+-]");

          if (textDisplayed.contains(regexAnyOperationDigit)) {
            while (true) {
              var indexOfFirstOperation = textDisplayed.indexOf(regexAnyOperationDigit);

              if (indexOfFirstOperation == -1) {
                break;
              }

              var num1 = double.parse(textDisplayed.substring(0, indexOfFirstOperation));

              var indexOfSecondOperation = textDisplayed.indexOf(
                  RegExp("[%/x+-]"), indexOfFirstOperation + 1
              );

              double num2;
              if (indexOfSecondOperation == -1) {
                num2 = double.parse(textDisplayed.substring(indexOfFirstOperation + 1));
              }else {
                num2 = double.parse(textDisplayed.substring(indexOfFirstOperation + 1, indexOfSecondOperation));
              }

              // Calculation
              var operation = textDisplayed.substring(
                  indexOfFirstOperation, indexOfFirstOperation + 1
              );

              double result = 0;
              if (operation == "+") {
                result = num1 + num2;
              }else if (operation == "-") {
                result = num1 - num2;
              }else if (operation == "x") {
                result = num1 * num2;
              }else if (operation == "/") {
                result = num1 / num2;
              }else if (operation == "%") {
                result = num1 % num2;
              }

              if (indexOfSecondOperation == -1) {
                var intResult = result.toInt();
                if (result - intResult.toDouble() == 0) {
                  textDisplayed = intResult.toString();
                }else {
                  textDisplayed = result.toString();
                }

                break;
              }else {
                textDisplayed = result.toString() + textDisplayed.substring(indexOfSecondOperation);
              }
            }
          }

          lastClickIsOperation = false;

          return;
        }else {
          // %, /, x, -, +
          textDisplayed += text;
        }
      }else {
        if (textDisplayed == "0") {
          textDisplayed = text;
        }else {
          textDisplayed += text;
        }
      }

      lastClickIsOperation = representsOperation;
    });
  }

}

class AllButtons extends StatelessWidget {

  final Function(String text, bool representsOperation) onButtonPressed;

  AllButtons({required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Expanded(
            child: RowOfButtons(1, onButtonPressed)
          ),
          SizedBox(height: 16),
          Expanded(
            child: RowOfButtons(2, onButtonPressed)
          ),
          SizedBox(height: 16),
          Expanded(
            child: RowOfButtons(3, onButtonPressed)
          ),
          SizedBox(height: 16),
          Expanded(
            child: RowOfButtons(4, onButtonPressed)
          ),
          SizedBox(height: 16),
          Expanded(
            child: RowOfButtons(5, onButtonPressed)
          ),
        ],
      ),
    );
  }
}

class RowOfButtons extends StatelessWidget {

  final int rowNumber;

  final Function(String text, bool representsOperation) onButtonPressed;

  RowOfButtons(this.rowNumber, this.onButtonPressed);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CalcButton(rowNumber, 1, onButtonPressed),
        ),
        SizedBox(width: 16),
        Expanded(
          child: CalcButton(rowNumber, 2, onButtonPressed),
        ),
        SizedBox(width: 16),
        Expanded(
          child: CalcButton(rowNumber, 3, onButtonPressed),
        ),
        SizedBox(width: 16),
        Expanded(
          child: CalcButton(rowNumber, 4, onButtonPressed),
        ),
      ],
    );
  }
}

class CalcButton extends StatelessWidget {

  final int rowNumber;
  final int columnNumber;

  final Function(String text, bool representsOperation) onButtonPressed;

  CalcButton(this.rowNumber, this.columnNumber, this.onButtonPressed);

  @override
  Widget build(BuildContext context) {
    bool showDark = false;
    bool representsOperation = false;
    String text = "M";

    if (rowNumber == 1 || columnNumber == 4) {
      showDark = true;
      representsOperation = true;
    }

    if (rowNumber == 1) {
      if (columnNumber == 1) {
        text = "AC";
      }else if (columnNumber == 2) {
        text = "%";
      }else if (columnNumber == 3) {
        text = "DEL";
      }else if (columnNumber == 4) {
        text = "/";
      }
    }else if (rowNumber == 2) {
      if (columnNumber == 1) {
        text = "7";
      }else if (columnNumber == 2) {
        text = "8";
      }else if (columnNumber == 3) {
        text = "9";
      }else if (columnNumber == 4) {
        text = "x";
      }
    }else if (rowNumber == 3) {
      if (columnNumber == 1) {
        text = "4";
      }else if (columnNumber == 2) {
        text = "5";
      }else if (columnNumber == 3) {
        text = "6";
      }else if (columnNumber == 4) {
        text = "-";
      }
    }else if (rowNumber == 4) {
      if (columnNumber == 1) {
        text = "1";
      }else if (columnNumber == 2) {
        text = "2";
      }else if (columnNumber == 3) {
        text = "3";
      }else if (columnNumber == 4) {
        text = "+";
      }
    }else if (rowNumber == 5) {
      if (columnNumber == 1) {
        text = "00";
      }else if (columnNumber == 2) {
        text = "0";
      }else if (columnNumber == 3) {
        text = ".";
      }else if (columnNumber == 4) {
        text = "=";
      }
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: showDark ? Colors.black : Colors.black12,
        borderRadius: BorderRadius.circular(20)
      ),
      child: TextButton(
        onPressed: () {
          onButtonPressed(text, representsOperation);
        },
        child: Text(
          text,
          style: TextStyle(
              color: showDark ? Colors.white : Colors.black,
              fontSize: showDark ? 28 : 23,
              fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}
