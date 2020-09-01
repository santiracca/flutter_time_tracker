import 'package:flutter/material.dart';
import 'package:timeTracker/app/home/models/job.dart';
import 'package:timeTracker/services/api_path.dart';
import 'package:timeTracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);

  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({
    @required this.uid,
  }) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> createJob(Job job) async => await _service.setData(
      path: APIPath.job(uid, 'job_abc'), data: job.toMap());

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data) => Job.fromMap(data));
}
