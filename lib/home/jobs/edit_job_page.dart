import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/home/models/job.dart';
import 'package:time_tracker/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context,
      {Job? job, required Database database}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  String _name = '';
  int? _ratePerHour;
  final jobNameFocusNode = FocusNode();
  final ratePerHourFocusNode = FocusNode();

  bool validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(context,
              title: 'Name already used',
              content: 'Please choose a different name',
              defaultActionText: 'ok');
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(name: _name, ratePerHour: _ratePerHour, id: id);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation failed', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormContents(),
      ),
    );
  }

  void _nameOnEditingComplete() {
    final newFocus = ratePerHourFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildFormContents() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Job name'),
        onSaved: (value) => _name = value!,
        validator: (value) => value!.isNotEmpty ? null : "Name can't be null",
        focusNode: jobNameFocusNode,
        initialValue: _name,
        onEditingComplete: _nameOnEditingComplete,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate per Hour'),
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
        focusNode: ratePerHourFocusNode,
        initialValue: _ratePerHour != null ? _ratePerHour.toString() : null,
      ),
    ];
  }
}
