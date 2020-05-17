import 'package:fivekmrun_flutter/offline_chart/details_tile.dart';
import 'package:flutter/material.dart';

class SelfieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subHeadStyle = theme.textTheme.subhead;

    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            IntrinsicHeight(
                child: Text("Selfie Статистика", style: subHeadStyle)),
            IntrinsicWidth(
              child: Row(
      
                children: <Widget>[
                  DetailsTile(
                    title: "брой участия",
                    value: "5",
                  ),
                  Container(width: 10,),
                  DetailsTile(
                    title: "средно темпо",
                    value: "5:23 мин/км",
                  ),
                  Container(width: 10,),
                  DetailsTile(
                    title: "движение в класация",
                    value: "5"
                  ),
                  // DetailsTile(
                  //   title: "последно бягане",
                  //   value: "20.05.2020"
                  // ),
                  Container(width: 10,),
                  IconButton(
                    icon: Icon(Icons.add),
                  )
                ],),
            )
          ],
        ));
  }
}
