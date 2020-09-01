import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timeTracker/common/firestore_exception_dialog.dart';
import 'package:timeTracker/common/platform_alert_dialog.dart';
import 'package:timeTracker/common/platform_exception_alert_dialog.dart';
import 'package:timeTracker/services/auth.dart';
import 'package:timeTracker/services/database.dart';

import 'models/job.dart';

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

  Future<void> _createJob(BuildContext context) async {
    try {
      final datatbase = Provider.of<Database>(context, listen: false);
      await datatbase.createJob(Job(name: 'Blogging', ratePerHour: 10));
    } on FirebaseException catch (e) {
      FirebaseExceptionAlertDialog(title: 'Operation failed', exception: e)
          .show(context);
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(context),
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
          final children = jobs.map((job) => Text(job.name)).toList();
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
