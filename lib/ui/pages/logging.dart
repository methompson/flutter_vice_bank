import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/log.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoggingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logging'),
      ),
      body: LoggingContent(),
    );
  }
}

class LoggingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<LoggingProvider, List<Log>>(
      selector: (_, p1) => p1.logs,
      builder: (_, logs, __) {
        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (_, index) {
            final log = logs[index];

            final date = DateFormat("MM/dd/yyyy").add_jm().format(log.date);

            final color = index % 2 == 0
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onInverseSurface;

            return ListTile(
              tileColor: color,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                        ),
                  ),
                  Text(log.message),
                ],
              ),
              subtitle: Text(log.message),
            );
          },
        );
      },
    );
  }
}
