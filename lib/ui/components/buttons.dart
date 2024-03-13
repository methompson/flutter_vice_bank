import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final Widget buttonContents;
  final void Function() _onPressed;
  final double? textSize;

  final double? leftMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? bottomMargin;
  final double? allMargin;

  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? allPadding;

  final bool _disabled;

  BasicButton({
    required this.buttonContents,
    required void Function() onPressed,
    this.textSize,
    this.leftMargin,
    this.rightMargin,
    this.topMargin,
    this.bottomMargin,
    this.allMargin,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
    this.allPadding,
    bool? disabled,
  })  : _onPressed = onPressed,
        _disabled = disabled ?? false;

  EdgeInsets get margin {
    if (allMargin != null) {
      return EdgeInsets.all(allMargin ?? 0.0);
    }

    return EdgeInsets.only(
      left: leftMargin ?? 0.0,
      right: rightMargin ?? 0.0,
      top: topMargin ?? 0.0,
      bottom: bottomMargin ?? 0.0,
    );
  }

  EdgeInsets get padding {
    if (allPadding != null) {
      return EdgeInsets.all(allPadding ?? 0.0);
    }

    return EdgeInsets.only(
      left: leftPadding ?? 0.0,
      right: rightPadding ?? 0.0,
      top: topPadding ?? 0.0,
      bottom: bottomPadding ?? 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onPressed = _disabled ? null : _onPressed;

    return Container(
      margin: margin,
      child: FilledButton(
        onPressed: onPressed,
        child: Container(
          padding: padding,
          child: buttonContents,
        ),
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String text;
  final void Function() _onPressed;
  final double? textSize;

  final double? leftMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? bottomMargin;
  final double? allMargin;

  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? allPadding;

  final bool _disabled;

  _TextButton({
    required this.text,
    required void Function() onPressed,
    this.textSize,
    this.leftMargin,
    this.rightMargin,
    this.topMargin,
    this.bottomMargin,
    this.allMargin,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
    this.allPadding,
    bool? disabled,
  })  : _onPressed = onPressed,
        _disabled = disabled ?? false;

  @override
  Widget build(context) {
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

    final widget = Text(
      text,
      textAlign: TextAlign.center,
      style: textStyle.copyWith(fontSize: size),
    );

    return BasicButton(
      onPressed: _onPressed,
      buttonContents: widget,
      leftMargin: leftMargin,
      rightMargin: rightMargin,
      topMargin: topMargin,
      bottomMargin: bottomMargin,
      allMargin: allMargin,
      leftPadding: leftPadding,
      rightPadding: rightPadding,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      allPadding: allPadding,
      disabled: _disabled,
    );
  }
}

class BasicTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  final double? leftMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? bottomMargin;
  final double? allMargin;

  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? allPadding;

  final bool _disabled;

  BasicTextButton({
    required this.text,
    required this.onPressed,
    this.leftMargin,
    this.rightMargin,
    this.topMargin,
    this.bottomMargin,
    this.allMargin,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
    this.allPadding,
    bool? disabled,
  }) : _disabled = disabled ?? false;

  @override
  Widget build(BuildContext context) {
    return _TextButton(
      onPressed: onPressed,
      text: text,
      leftMargin: leftMargin,
      rightMargin: rightMargin,
      topMargin: topMargin,
      bottomMargin: bottomMargin,
      allMargin: allMargin,
      leftPadding: leftPadding,
      rightPadding: rightPadding,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      allPadding: allPadding,
      disabled: _disabled,
    );
  }
}

class BasicBigTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  final double? leftMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? bottomMargin;
  final double? allMargin;

  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? allPadding;

  final bool _disabled;

  BasicBigTextButton({
    required this.text,
    required this.onPressed,
    this.leftMargin,
    this.rightMargin,
    this.topMargin,
    this.bottomMargin,
    this.allMargin,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
    this.allPadding,
    bool? disabled,
  }) : _disabled = disabled ?? false;

  @override
  Widget build(BuildContext context) {
    return _TextButton(
      onPressed: onPressed,
      text: text,
      textSize: 20.0,
      leftMargin: leftMargin,
      rightMargin: rightMargin,
      topMargin: topMargin,
      bottomMargin: bottomMargin,
      allMargin: allMargin,
      leftPadding: leftPadding,
      rightPadding: rightPadding,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      allPadding: allPadding,
      disabled: _disabled,
    );
  }
}

class BasicIconButton extends StatelessWidget {
  final Icon icon;
  final void Function() onPressed;

  final double? leftMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? bottomMargin;
  final double? allMargin;

  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? allPadding;

  final bool _disabled;

  BasicIconButton({
    required this.icon,
    required this.onPressed,
    this.leftMargin,
    this.rightMargin,
    this.topMargin,
    this.bottomMargin,
    this.allMargin,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
    this.allPadding,
    bool? disabled,
  }) : _disabled = disabled ?? false;

  @override
  Widget build(BuildContext context) {
    return BasicButton(
      onPressed: onPressed,
      buttonContents: icon,
      leftMargin: leftMargin,
      rightMargin: rightMargin,
      topMargin: topMargin,
      bottomMargin: bottomMargin,
      allMargin: allMargin,
      leftPadding: leftPadding,
      rightPadding: rightPadding,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      allPadding: allPadding,
      disabled: _disabled,
    );
  }
}
