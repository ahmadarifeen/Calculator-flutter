import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '0';
  String _result = '';
  Color _displayTextColor = Colors.black;

  bool _isOpenBracket = false;
  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _expression = '0';
        _result = '';
      } else if (buttonText == '=') {
        try {
          // Remove non-numeric characters before evaluation
          String sanitizedExpression =
              _expression.replaceAll(RegExp(r'[^0-9+\-*/().]'), '');
          _result = _evaluateExpression(sanitizedExpression);
          _expression = _result;
          _displayTextColor = Colors.black;
        } catch (e) {
          _result = 'Error';
        }
      } else if (buttonText == '()') {
        if (_isOpenBracket) {
          _expression += ')';
          _isOpenBracket = false;
        } else {
          _expression += '(';
          _isOpenBracket = true;
        }
      } else {
        if (_expression == '0' && buttonText != '.') {
          _expression = '';
        }
        _expression += buttonText;
        _displayTextColor = Colors.black;
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      return '${exp.evaluate(EvaluationType.REAL, cm)}';
    } catch (e) {
      return 'Error';
    }
  }

  Widget _buildButton(String buttonText, {bool isBracket = false}) {
    Color bgColor = Colors.white;
    Color textColor = Colors.black;

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(isBracket ? '()' : buttonText),
          child: Text(
            isBracket ? '()' : '$buttonText',
            style: TextStyle(fontSize: 35, color: textColor),
          ),
          style: ElevatedButton.styleFrom(
            shape: isBracket ? CircleBorder() : StadiumBorder(),
            primary: bgColor,
            padding: EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _expression,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _displayTextColor,
                      fontSize: 100,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton('AC'),
                  _buildButton('+/-'),
                  _buildButton('%'),
                  _buildButton('/'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('*'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('-'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('+'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton('0'),
                  _buildButton('.'),
                  _buildButton('()',
                      isBracket: true), // Bracket button with custom flag
                  _buildButton('='),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
