import 'package:fivekmrun_flutter/common/milestone_gauge.dart';
import 'package:fivekmrun_flutter/state/result_model.dart';
import 'package:fivekmrun_flutter/state/results_resource.dart';
import 'package:fivekmrun_flutter/state/run_model.dart';
import 'package:flutter/material.dart';

class RunDetailsPage extends StatelessWidget {
  const RunDetailsPage({Key key}) : super(key: key);

  Widget buildPositionGauge(Run run) {
    if (run.isSelfie) return SizedBox.shrink();

    ResultsResource results = ResultsResource();
    return FutureBuilder<List<Result>>(
        future: results.getAll(run.eventId),
        builder: (BuildContext context, AsyncSnapshot<List<Result>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return MilestoneGauge(run.position, 400);
              else
                return MilestoneGauge(run.position, snapshot.data.length);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final Run run = ModalRoute.of(context).settings.arguments;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(run.displayDate)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(flex: 2, child: SizedBox()),
                Expanded(
                    flex: 3,
                    child: Stack(
                      children: <Widget>[
                        buildPositionGauge(run),
                        Positioned(
                          bottom: 6,
                          left: 0,
                          right: 0,
                          child: Text(
                            "Позиция",
                            style: theme.textTheme.title,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                Expanded(flex: 2, child: SizedBox()),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    CircleWidget(run.pace, "мин/км"),
                    SizedBox(height: 10),
                    Text(
                      "Темпо",
                      style: theme.textTheme.subtitle,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    CircleWidget(run.time, "мин"),
                    SizedBox(height: 10),
                    Text(
                      "Време",
                      style: theme.textTheme.subtitle,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    CircleWidget(run.speed, "км/ч"),
                    SizedBox(height: 10),
                    Text(
                      "Скорост",
                      style: theme.textTheme.subtitle,
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconText(
                  icon: Icons.calendar_today,
                  text: run.displayDate,
                ),
                IconText(
                  icon: Icons.pin_drop,
                  text: (run.isSelfie) ? "Selfie" : run.location,
                ),
              ],
            ),
            if (run.isSelfie)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconText(icon: Icons.watch, text: run.totalTime + " мин"),
                  IconText(
                      icon: Icons.straighten,
                      text: (run.distance / 1000).toStringAsFixed(2) + " км"),
                ],
              ),
            SizedBox(height: 20),
            // if (!run.isSelfie)
            //   CompareTime(
            //     text: "Предишно бягане: ",
            //     time: run.differenceFromPrevious,
            //   ),
            // if (!run.isSelfie) SizedBox(height: 10),
            // if (!run.isSelfie)
            //   CompareTime(
            //     text: "Най-добро бягане: ",
            //     time: run.differenceFromBest,
            //   ),
          ],
        ),
      ),
    );
  }
}

class CircleWidget extends StatelessWidget {
  final String value;
  final String measurement;

  CircleWidget(this.value, this.measurement);

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.subhead.copyWith(color: Colors.black);
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          Text(this.value, style: textStyle),
          Text(this.measurement, style: textStyle)
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const IconText({Key key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: theme.accentColor,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            text,
            style: theme.textTheme.subtitle,
          ),
        ),
      ],
    );
  }
}

class CompareTime extends StatelessWidget {
  final int time;
  final String text;
  const CompareTime({Key key, this.time, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final color = time < 0
        ? Color.fromRGBO(0, 173, 25, 1)
        : Color.fromRGBO(250, 32, 87, 1);

    final numberStyle = textTheme.subtitle.copyWith(color: color);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: textTheme.subtitle,
        ),
        Text(
          Run.timeInSecondsToString(time, sign: true),
          style: numberStyle,
        ),
      ],
    );
  }
}

class RunDetail extends StatelessWidget {
  final String value;
  final String label;
  const RunDetail({Key key, this.value, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: textTheme.subtitle,
        ),
        Text(
          value,
          style: textTheme.subtitle,
        ),
      ],
    );
  }
}
