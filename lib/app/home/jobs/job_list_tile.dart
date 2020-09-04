import 'package:flutter/material.dart';
import 'package:timeTracker/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobListTile({Key key, @required this.job, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(Icons.chevron_right),
      title: Text(job.name),
      onTap: onTap,
    );
  }
}
