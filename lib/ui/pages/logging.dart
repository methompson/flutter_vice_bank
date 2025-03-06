import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/log.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';

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
        return Column(
          children: [
            BasicBigTextButton(
              text: 'Clear Logs',
              onPressed: () {
                context.read<LoggingProvider>().clearLogs();
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (_, index) {
                  final log = logs[index];

                  final date =
                      DateFormat("MM/dd/yyyy").add_jm().format(log.date);

                  final bgColor = index % 2 == 0
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onInverseSurface;

                  var icon = Icon(
                    Icons.info,
                    color: Colors.blue,
                  );
                  if (log.type == MessageType.error) {
                    icon = Icon(
                      Icons.error,
                      color: Colors.red,
                    );
                  } else if (log.type == MessageType.warning) {
                    icon = Icon(
                      Icons.warning,
                      color: Colors.orangeAccent[400],
                    );
                  }

                  return ListTile(
                    leading: icon,
                    tileColor: bgColor,
                    // dense: true,
                    title: Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          // fontSize: 11,
                          ),
                    ),
                    subtitle: Text(log.message),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
