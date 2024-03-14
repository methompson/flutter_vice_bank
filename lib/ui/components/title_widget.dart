import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  TitleWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: Theme.of(context).copyWith().textTheme.headlineMedium,
      ),
    );
  }
}

class AddIconButton extends StatelessWidget {
  final Function(BuildContext) onPressed;

  AddIconButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(Icons.add),
        onPressed: () => onPressed(context),
      ),
    );
  }
}

class TitleWithIconButton extends StatelessWidget {
  final String title;
  final Widget iconButton;

  TitleWithIconButton({
    required this.title,
    required this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).copyWith().textTheme.headlineMedium,
          ),
          iconButton,
        ],
      ),
    );
  }
}
