import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillSheetTypeSelectPage extends StatelessWidget {
  final void Function(PillSheetType type) callback;
  final PillSheetType selectedPillSheetType;

  const PillSheetTypeSelectPage(
      {Key key, this.callback, this.selectedPillSheetType})
      : super(key: key);
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "1/4",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 24),
              Text("飲んでいるピルのタイプはどれ？",
                  style: FontType.title.merge(TextColorStyle.standard)),
              SizedBox(height: 24),
              Container(
                height: 461,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      PillSheetType.values.map((e) => _pillSheet(e)).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _pillSheet(PillSheetType type) {
    return GestureDetector(
      onTap: () {
        callback(type);
      },
      child: PillSheet(
        pillSheetType: type,
        selected: selectedPillSheetType == type,
      ),
    );
  }
}
