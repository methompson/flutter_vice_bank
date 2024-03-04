import 'package:flutter/material.dart';

class _BasicButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final double? textSize;

  _BasicButton({
    required this.text,
    required this.onPressed,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    final Set<MaterialState> materialStates = {
      MaterialState.focused,
    };

    final size = textSize ?? 16.0;

    final textStyle = Theme.of(context)
            .filledButtonTheme
            .style
            ?.textStyle
            ?.resolve(materialStates) ??
        TextStyle();

    return FilledButton(
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle.copyWith(fontSize: size),
      ),
    );
  }
}

class BasicTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  BasicTextButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _BasicButton(
      onPressed: onPressed,
      text: text,
    );
  }
}

class BasicBigTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  BasicBigTextButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _BasicButton(
      onPressed: onPressed,
      text: text,
      textSize: 20.0,
    );
  }
}
