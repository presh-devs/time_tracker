import 'package:flutter/material.dart';
import 'package:time_tracker/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder extends StatelessWidget {
  const ListItemsBuilder(
      {Key? key, required this.snapshot, required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<List> snapshot;
  final ItemWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List? items = snapshot.data;
      if (items!.isNotEmpty) {
        return _buildList(items);
      } else {
        return const EmptyContent();
      }
    } else if (snapshot.hasError) {
      return const EmptyContent(
        title: 'Something went wrong',
        message: "Can't load items now",
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index]);
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 0.5),
    );
  }
}
