import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/home/job_entries/job_entries_page.dart';
import 'package:time_tracker/home/jobs/job_list_tile.dart';
import 'package:time_tracker/home/jobs/list_item_builder.dart';
import 'package:time_tracker/services/database.dart';

import '../models/job.dart';
import 'edit_job_page.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jobs',
        ),
        actions: [
          IconButton(
            onPressed: () => EditJobPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            key: Key('job- ${job.id}'),
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: e);
    }
  }
}
