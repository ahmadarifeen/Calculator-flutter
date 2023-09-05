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
  String _expression = '';
  String _result = '0'; // Initialize the result as '0'
  Color _displayTextColor = Colors.black;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _expression = '';
        _result = '0';
      } else if (buttonText == '=') {
        try {
          _result = _evaluateExpression(_expression);
          _expression = _result;
          _displayTextColor = Colors.black;
        } catch (e) {
          _result = 'Error';
        }
      } else {
        if (_result == '0') {
          _result = '';
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

  Widget _buildButton(String buttonText) {
    Color bgColor = Colors.white;
    Color textColor = Colors.black;

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(buttonText),
          child: Text(
            '$buttonText',
            style: TextStyle(fontSize: 35, color: textColor),
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
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
        centerTitle: true, // Center the title text in the app bar
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Calculator display
            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // Set scroll direction to horizontal
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      _result.isEmpty
                          ? '$_expression'
                          : '$_expression = $_result',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: _displayTextColor,
                        fontSize: 100,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildButton('AC'), // 'AC' button
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
                _buildButton('*'), // Use '*' for multiplication
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
                ElevatedButton(
                  onPressed: () {
                    _onButtonPressed('0');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    primary: Colors.white,
                  ),
                  child: Text(
                    '0',
                    style: TextStyle(fontSize: 35, color: Colors.black),
                  ),
                ),
                _buildButton('.'),
                _buildButton('='),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
