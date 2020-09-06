import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeTracker/app/home/job_entries/job_entries_page.dart';
import 'package:timeTracker/app/home/jobs/edit_jobs_page.dart';
import 'package:timeTracker/app/home/jobs/job_list_tile.dart';
import 'package:timeTracker/app/home/jobs/list_items_builder.dart';
import 'package:timeTracker/common/firestore_exception_dialog.dart';
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

  Future<void> _delete(BuildContext context, Job job) async {
    final db = Provider.of<Database>(context, listen: false);
    try {
      await db.deleteJob(job);
    } on FirebaseException catch (e) {
      FirebaseExceptionAlertDialog(
        exception: e,
        title: "Oopps",
      ).show(context);
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
        onPressed: () => EditJobsPage.show(
            context, Provider.of<Database>(context, listen: false)),
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
        return ListItemBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            onDismissed: (direction) => _delete(context, job),
            key: Key('job-${job.id}'),
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );
      },
    );
  }
}
