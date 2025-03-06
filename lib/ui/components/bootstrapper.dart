import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/ui/theme.dart';

class BootStrapper extends StatefulWidget {
  final Widget app;
  final Future<void> Function(BuildContext context) initFunction;
  final Widget? loadingPage;

  BootStrapper({
    required this.app,
    required this.initFunction,
    this.loadingPage,
  });

  @override
  BootStrapperState createState() => BootStrapperState();
}

class BootStrapperState extends State<BootStrapper> {
  var finished = false;
  Exception? exception;

  @override
  initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    try {
      await widget.initFunction(context);
    } catch (e) {
      if (e is Exception) {
        setState(() {
          exception = e;
        });
      } else {
        setState(() {
          exception = Exception('$e');
        });
      }
    }

    setState(() {
      finished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      if (exception != null) {
        return BasicErrorPage(exception.toString());
      }
      return widget.app;
    }

    return widget.loadingPage ?? BasicLoadingPage();
  }
}

class BasicLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

class BasicErrorPage extends StatelessWidget {
  final String message;

  BasicErrorPage(this.message);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Text(message),
          ),
        ),
      ),
    );
  }
}
