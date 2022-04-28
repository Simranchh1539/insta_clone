import 'package:flutter/material.dart';

class TextFieldForm extends StatelessWidget {
  final TextEditingController textController;
  final bool isPass;
  final String hintText;
  final Function onchanged;
  final TextInputType textInputType;
  const TextFieldForm({
    Key key,
    @required this.textController,
    @required this.isPass,
    @required this.hintText,
    @required this.textInputType,
    this.onchanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(13),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      onChanged: onchanged,
    );
  }
}
