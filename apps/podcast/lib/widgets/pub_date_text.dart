import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class PubDateText extends StatelessWidget {
  final DateTime pubDate;

  const PubDateText(this.pubDate, {super.key});

  static final _dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return Timeago(
      date: pubDate,
      builder: (_, value) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: value),
              if (DateTime.now().difference(pubDate).inDays > 1)
                TextSpan(text: ' (${_dateFormat.format(pubDate)})'),
            ],
          ),
        );
      },
    );
  }
}
