import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WTInputField extends StatelessWidget {
  const WTInputField(
      {Key? key,
      required TextEditingController controller,
      FocusNode? focusNode,
      String? Function(String?)? validator,
      String? label,
      VoidCallback? onEditingComplete,
      bool isPassword = false,
      TextInputAction? textInputAction,
      bool autofocus = false,
      TextInputType? textInputType})
      : _controller = controller,
        _focusNode = focusNode,
        _validator = validator,
        _label = label,
        _onEditingComplete = onEditingComplete,
        _textInputAction = textInputAction,
        _obscure = isPassword,
        _autofocus = autofocus,
        _textInputType = textInputType,
        super(key: key);

  final TextEditingController _controller;
  final FocusNode? _focusNode;
  final String? Function(String?)? _validator;
  final String? _label;
  final VoidCallback? _onEditingComplete;
  final bool _obscure;
  final TextInputAction? _textInputAction;
  final bool _autofocus;
  final TextInputType? _textInputType;

  @override
  Widget build(BuildContext context) {
    _controller
      ..selection = TextSelection.collapsed(offset: _controller.text.length);

    return TextFormField(
      controller: _controller,
      keyboardType: _textInputType,
      obscuringCharacter: '*',
      obscureText: _obscure,
      focusNode: _focusNode,
      onEditingComplete: _onEditingComplete,
      textInputAction: _textInputAction,
      autofocus: _autofocus,
      decoration: InputDecoration(
          labelText: _label,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0)),
          errorStyle: TextStyle(color: Colors.red)),
      validator: _validator,
    );
  }
}
