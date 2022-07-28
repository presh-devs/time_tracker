import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../jobs/list_item_builder.dart';
import 'entries_bloc.dart';
import 'package:time_tracker/services/database.dart';
import 'entries_list_tile.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(database: database),
      child: const EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context, listen: false);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListItemsBuilder(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
