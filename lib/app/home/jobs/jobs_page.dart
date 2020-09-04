import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeTracker/app/home/jobs/edit_jobs_page.dart';
import 'package:timeTracker/app/home/jobs/job_list_tile.dart';
import 'package:timeTracker/common/platform_alert_dialog.dart';
import 'package:timeTracker/services/auth.dart';
import 'package:timeTracker/services/database.dart';

import '../models/job.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signout(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: "Logout",
      content: "Are you sure you want to logout",
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignOut) {
      _signout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs Page"),
        actions: [
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EditJobsPage.show(context),
        child: Icon(Icons.add),
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs
              .map((job) => JobListTile(
                    job: job,
                    onTap: () => EditJobsPage.show(context, job: job),
                  ))
              .toList();
          return ListView(
            children: children,
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Some error has occurred"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
