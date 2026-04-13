import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0'; 
  String _firstOperand = ''; 
  String _operator = ''; 
  bool _shouldResetDisplay = false; 
  String _expression = ''; 

  // Task 1: Complete initState()
  @override
  void initState() {
    super.initState();
    _display = '0';
    _firstOperand = '';
    _operator = '';
    _shouldResetDisplay = false;
    _expression = '';
  }

  // Task 2: Complete _onNumberPressed(String number)
  void _onNumberPressed(String number) {
    setState(() {
      if (_display == '0' || _shouldResetDisplay) {
        _display = number;
        _shouldResetDisplay = false;
      } else {
        if (_display.length < 12) {
          _display += number;
        }
      }
    });
  }

  // Task 3: Complete _onDecimalPressed()
  void _onDecimalPressed() {
    setState(() {
      if (_shouldResetDisplay) {
        _display = '0.';
        _shouldResetDisplay = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  // Task 4: Complete _onOperatorPressed(String operator)
  void _onOperatorPressed(String operator) {
    setState(() {
      _firstOperand = _display;
      _operator = operator;
      _expression = '$_firstOperand $operator';
      _shouldResetDisplay = true;
    });
  }

  // Task 5: Complete _onScientificPressed(String function)
  void _onScientificPressed(String function) {
    setState(() {
      double num = double.tryParse(_display) ?? 0;
      double result = 0;
      String expr = '';

      switch (function) {
        case 'sin':
          result = sin(num * pi / 180);
          expr = 'sin($num°) = ${_formatResult(result)}';
          break;
        case 'cos':
          result = cos(num * pi / 180);
          expr = 'cos($num°) = ${_formatResult(result)}';
          break;
        case 'tan':
          if (num % 180 == 90 || num % 180 == -90) {
            _display = 'Error';
            _expression = 'tan($num°) is undefined';
            _shouldResetDisplay = true;
            return;
          }
          result = tan(num * pi / 180);
          expr = 'tan($num°) = ${_formatResult(result)}';
          break;
        case '√':
          if (num < 0) {
            _display = 'Error';
            _expression = 'Cannot sqrt negative number';
            _shouldResetDisplay = true;
            return;
          }
          result = sqrt(num);
          expr = '√($num) = ${_formatResult(result)}';
          break;
        case 'log':
          if (num <= 0) {
            _display = 'Error';
            _expression = 'log requires positive number';
            _shouldResetDisplay = true;
            return;
          }
          result = log(num) / ln10;
          expr = 'log($num) = ${_formatResult(result)}';
          break;
        case 'ln':
          if (num <= 0) {
            _display = 'Error';
            _expression = 'ln requires positive number';
            _shouldResetDisplay = true;
            return;
          }
          result = log(num);
          expr = 'ln($num) = ${_formatResult(result)}';
          break;
        case 'x²':
          result = num * num;
          expr = '$num² = ${_formatResult(result)}';
          break;
        case 'π':
          result = pi;
          expr = 'π = ${_formatResult(result)}';
          break;
        case 'e':
          result = e;
          expr = 'e = ${_formatResult(result)}';
          break;
        case '±':
          result = num * -1;
          expr = '±($num) = ${_formatResult(result)}';
          break;
        default:
          return;
      }

      _display = _formatResult(result);
      _expression = expr;
      _shouldResetDisplay = true;
    });
  }

  // ============================================================
  // PROVIDED FUNCTIONS (Do not modify below this line)
  // ============================================================

  void _calculate() {
    if (_firstOperand.isEmpty || _operator.isEmpty) return;

    double num1 = double.tryParse(_firstOperand) ?? 0;
    double num2 = double.tryParse(_display) ?? 0;
    double result = 0;

    setState(() {
      switch (_operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '×':
          result = num1 * num2;
          break;
        case '÷':
          if (num2 == 0) {
            _display = 'Error';
            _expression = 'Cannot divide by zero';
            _resetAfterError();
            return;
          }
          result = num1 / num2;
          break;
        case '^':
          result = pow(num1, num2).toDouble();
          break;
        case '%':
          if (num2 == 0) {
            _display = 'Error';
            _expression = 'Cannot modulo by zero';
            _resetAfterError();
            return;
          }
          result = num1 % num2;
          break;
      }

      _expression = '$_firstOperand $_operator $_display = ${_formatResult(result)}';
      _display = _formatResult(result);
      _firstOperand = '';
      _operator = '';
      _shouldResetDisplay = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstOperand = '';
      _operator = '';
      _shouldResetDisplay = false;
      _expression = '';
    });
  }

  void _clearEntry() {
    setState(() {
      _display = '0';
    });
  }

  void _backspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _resetAfterError() {
    _firstOperand = '';
    _operator = '';
    _shouldResetDisplay = true;
  }

  String _formatResult(double result) {
    if (result.isNaN || result.isInfinite) {
      return 'Error';
    }
    if (result == result.toInt()) {
      return result.toInt().toString();
    }
    String formatted = result.toStringAsFixed(8);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    return formatted;
  }

  Widget _buildButton(
    String text, {
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onPressed,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: backgroundColor ?? const Color(0xFF333333),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Container(
              height: 65,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: text.length > 2 ? 18 : 24,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator Exam'),
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _display,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (_operator.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Operator: $_operator',
                          style: const TextStyle(fontSize: 14, color: Colors.orange),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey[800],
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('sin', backgroundColor: const Color(0xFF505050), onPressed: () => _onScientificPressed('sin')),
                  _buildButton('cos', backgroundColor: const Color(0xFF505050), onPressed: () => _onScientificPressed('cos')),
                  _buildButton('tan', backgroundColor: const Color(0xFF505050), onPressed: () => _onScientificPressed('tan')),
                  _buildButton('log', backgroundColor: const Color(0xFF505050), onPressed: () => _onScientificPressed('log')),
                  _buildButton('ln', backgroundColor: const Color(0xFF505050), onPressed: () => _onScientificPressed('ln')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('√', backgroundColor: const Color(0xFF505050), onPressed: () => _onScientificPressed('√')),
                  _buildButton('x²', backgroundColor: const Color(0xFF505050), onPressed: () => _onScientificPressed('x²')),
                  _buildButton('^', backgroundColor: const Color(0xFF505050), onPressed: () => _onOperatorPressed('^')),
                  _buildButton('π', backgroundColor: const Color(0xFF505050), onPressed: () => _onScientificPressed('π')),
                  _buildButton('e', backgroundColor: const Color(0xFF505050), onPressed: () => _onScientificPressed('e')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('C', backgroundColor: const Color(0xFFFF6B6B), onPressed: _clear),
                  _buildButton('CE', backgroundColor: const Color(0xFFFF8E72), onPressed: _clearEntry),
                  _buildButton('⌫', backgroundColor: const Color(0xFF505050), onPressed: _backspace),
                  _buildButton('%', backgroundColor: const Color(0xFFFF9500), onPressed: () => _onOperatorPressed('%')),
                  _buildButton('÷', backgroundColor: const Color(0xFFFF9500), onPressed: () => _onOperatorPressed('÷')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('7', onPressed: () => _onNumberPressed('7')),
                  _buildButton('8', onPressed: () => _onNumberPressed('8')),
                  _buildButton('9', onPressed: () => _onNumberPressed('9')),
                  _buildButton('×', backgroundColor: const Color(0xFFFF9500), onPressed: () => _onOperatorPressed('×')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('4', onPressed: () => _onNumberPressed('4')),
                  _buildButton('5', onPressed: () => _onNumberPressed('5')),
                  _buildButton('6', onPressed: () => _onNumberPressed('6')),
                  _buildButton('-', backgroundColor: const Color(0xFFFF9500), onPressed: () => _onOperatorPressed('-')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('1', onPressed: () => _onNumberPressed('1')),
                  _buildButton('2', onPressed: () => _onNumberPressed('2')),
                  _buildButton('3', onPressed: () => _onNumberPressed('3')),
                  _buildButton('+', backgroundColor: const Color(0xFFFF9500), onPressed: () => _onOperatorPressed('+')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('±', onPressed: () => _onScientificPressed('±')),
                  _buildButton('0', onPressed: () => _onNumberPressed('0')),
                  _buildButton('.', onPressed: _onDecimalPressed),
                  _buildButton('=', backgroundColor: const Color(0xFF34C759), onPressed: _calculate),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}