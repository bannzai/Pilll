import 'package:flutter/material.dart';

class RecordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      children: List.generate(28, (index) {
        return Center(
          child: Text(
            'Item $index',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
      }),
    );
  }
}
