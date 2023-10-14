import 'package:disney_voting/controllers/voting_controller.dart';
import 'package:disney_voting/ui/screens/dashboard/components/report/components/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../config/config.dart';
import '../../../../../../controllers/states.dart';

class Top5Chart extends StatefulWidget {
  const Top5Chart({super.key});

  @override
  State<StatefulWidget> createState() => Top5ChartState();
}

class Top5ChartState extends State {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Top 5 Disney Heroes',
          style: TextStyle(fontWeight: FontWeight.bold, color: Palette.primary),
        ),
        Consumer<VotingController>(builder: (context, vote, child) {
          return vote.states.status == Status.loading
              ? const AspectRatio(
                  aspectRatio: 1.3,
                  child: Center(child: CircularProgressIndicator()),
                )
              : vote.states.status == Status.completed
                  ? vote.top5.isNotEmpty
                      ? Top5BarChart(charList: vote.top5)
                      : AspectRatio(
                          aspectRatio: 1.3,
                          child: Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'No data found.',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          )),
                        )
                  : Text(vote.states.message!);
        }),
      ],
    );
  }
}
