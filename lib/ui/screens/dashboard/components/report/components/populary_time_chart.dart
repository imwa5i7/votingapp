import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_voting/controllers/voting_controller.dart';
import 'package:disney_voting/ui/widgets/app_images.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../config/config.dart';
import '../../../../../../data/responses/responses.dart';

class PopularityTimeChart extends StatefulWidget {
  const PopularityTimeChart({super.key});

  @override
  State<StatefulWidget> createState() => PopularityTimeChartState();
}

class PopularityTimeChartState extends State {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Character Popularity by Time of Day',
          style: TextStyle(fontWeight: FontWeight.bold, color: Palette.primary),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: instance<FirebaseFirestore>()
                .collection(Constants.charRef)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                List<DisneyCharacter> votingList = [];
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  DisneyCharacter character = DisneyCharacter.fromJson(
                      snapshot.data!.docs[i].data() as Map<String, dynamic>);
                  votingList.add(character);
                }

                DisneyCharacter morning = votingList[0];
                DisneyCharacter noon = votingList[0];
                DisneyCharacter evening = votingList[0];
                DisneyCharacter night = votingList[0];

                for (var i = 0; i < votingList.length; i++) {
                  if (votingList[i].morningVotes! > morning.morningVotes!) {
                    morning = votingList[i];
                  }
                  if (votingList[i].noonVotes! > noon.noonVotes!) {
                    noon = votingList[i];
                  }
                  if (votingList[i].eveningVotes! > evening.eveningVotes!) {
                    evening = votingList[i];
                  }
                  if (votingList[i].nightVotes! > night.nightVotes!) {
                    night = votingList[i];
                  }
                }

                log(votingList.length.toString());
                return Column(
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: Sizes.s20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Indicator(
                                color: Colors.blue,
                                text: 'Morning',
                                isSquare: false,
                                size: touchedIndex == 0 ? 18 : 16,
                                textColor: touchedIndex == 0
                                    ? Palette.primary
                                    : Palette.disable,
                              ),
                              Indicator(
                                color: Colors.yellow,
                                text: 'Afternoon',
                                isSquare: false,
                                size: touchedIndex == 1 ? 18 : 16,
                                textColor: touchedIndex == 1
                                    ? Palette.primary
                                    : Palette.disable,
                              ),
                              Indicator(
                                color: Colors.purple,
                                text: 'Evening',
                                isSquare: false,
                                size: touchedIndex == 2 ? 18 : 16,
                                textColor: touchedIndex == 2
                                    ? Palette.primary
                                    : Palette.disable,
                              ),
                              Indicator(
                                color: Colors.green,
                                text: 'Night',
                                isSquare: false,
                                size: touchedIndex == 3 ? 18 : 16,
                                textColor: touchedIndex == 3
                                    ? Palette.primary
                                    : Palette.disable,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1.1,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback:
                                        (FlTouchEvent event, pieTouchResponse) {
                                      setState(() {
                                        if (!event
                                                .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 0,
                                  sections: showingSections(
                                      [morning, noon, evening, night]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            }),
      ],
    );
  }

  List<PieChartSectionData> showingSections(List<DisneyCharacter> popularData) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? Sizes.s16 : Sizes.s12;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: popularData[0].morningVotes!.toDouble(),
            title: popularData[0].name!.split(' ').first,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              popularData[0].image!,
              size: widgetSize,
              borderColor: Colors.blue,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: popularData[1].noonVotes!.toDouble(),
            title: popularData[1].name!.split(' ').first,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              popularData[1].image!,
              size: widgetSize,
              borderColor: Colors.yellow,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: popularData[2].eveningVotes!.toDouble(),
            title: popularData[2].name!.split(' ').first,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              popularData[2].image!,
              size: widgetSize,
              borderColor: Colors.purple,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: popularData[3].nightVotes!.toDouble(),
            title: popularData[3].name!.split(' ').first,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              popularData[3].image!,
              size: widgetSize,
              borderColor: Colors.green,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: CustomImage(
          imageUrl: svgAsset,
          fit: BoxFit.contain,
          height: size,
          width: size,
        ),
      ),
    );
  }
}

// import 'package:disney_voting/config/config.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class ReportsWidget extends StatefulWidget {
//   const ReportsWidget({super.key});

//   @override
//   State<StatefulWidget> createState() => ReportsWidgetState();
// }

// class ReportsWidgetState extends State {
//   int touchedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: Column(
//         children: <Widget>[
//           const SizedBox(
//             height: 28,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Indicator(
//                 color: Colors.blue,
//                 text: 'One',
//                 isSquare: false,
//                 size: touchedIndex == 0 ? 18 : 16,
//                 textColor:
//                     touchedIndex == 0 ? Palette.primary : Palette.disable,
//               ),
//               Indicator(
//                 color: Colors.yellow,
//                 text: 'Two',
//                 isSquare: false,
//                 size: touchedIndex == 1 ? 18 : 16,
//                 textColor:
//                     touchedIndex == 1 ? Palette.primary : Palette.disable,
//               ),
//               Indicator(
//                 color: Colors.pink,
//                 text: 'Three',
//                 isSquare: false,
//                 size: touchedIndex == 2 ? 18 : 16,
//                 textColor:
//                     touchedIndex == 2 ? Palette.primary : Palette.disable,
//               ),
//               Indicator(
//                 color: Colors.green,
//                 text: 'Four',
//                 isSquare: false,
//                 size: touchedIndex == 3 ? 18 : 16,
//                 textColor:
//                     touchedIndex == 3 ? Palette.primary : Palette.disable,
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 18,
//           ),
//           Expanded(
//             child: AspectRatio(
//               aspectRatio: 1,
//               child: PieChart(
//                 PieChartData(
//                   pieTouchData: PieTouchData(
//                     touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                       setState(() {
//                         if (!event.isInterestedForInteractions ||
//                             pieTouchResponse == null ||
//                             pieTouchResponse.touchedSection == null) {
//                           touchedIndex = -1;
//                           return;
//                         }
//                         touchedIndex = pieTouchResponse
//                             .touchedSection!.touchedSectionIndex;
//                       });
//                     },
//                   ),
//                   startDegreeOffset: 180,
//                   borderData: FlBorderData(
//                     show: false,
//                   ),
//                   sectionsSpace: 1,
//                   centerSpaceRadius: 0,
//                   sections: showingSections(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<PieChartSectionData> showingSections() {
//     return List.generate(
//       4,
//       (i) {
//         final isTouched = i == touchedIndex;
//         const color0 = Colors.blue;
//         const color1 = Colors.yellow;
//         const color2 = Colors.pink;
//         const color3 = Colors.green;

//         switch (i) {
//           case 0:
//             return PieChartSectionData(
//               color: color0,
//               value: 25,
//               title: '',
//               radius: 80,
//               titlePositionPercentageOffset: 0.55,
//               borderSide: isTouched
//                   ? const BorderSide(color: Palette.error, width: 6)
//                   : BorderSide(color: Palette.error.withOpacity(0)),
//             );
//           case 1:
//             return PieChartSectionData(
//               color: color1,
//               value: 25,
//               title: '',
//               radius: 65,
//               titlePositionPercentageOffset: 0.55,
//               borderSide: isTouched
//                   ? const BorderSide(color: Palette.error, width: 6)
//                   : BorderSide(color: Palette.error.withOpacity(0)),
//             );
//           case 2:
//             return PieChartSectionData(
//               color: color2,
//               value: 25,
//               title: '',
//               radius: 60,
//               titlePositionPercentageOffset: 0.6,
//               borderSide: isTouched
//                   ? const BorderSide(color: Palette.error, width: 6)
//                   : BorderSide(color: Palette.error.withOpacity(0)),
//             );
//           case 3:
//             return PieChartSectionData(
//               color: color3,
//               value: 25,
//               title: '',
//               radius: 70,
//               titlePositionPercentageOffset: 0.55,
//               borderSide: isTouched
//                   ? const BorderSide(color: Palette.error, width: 6)
//                   : BorderSide(color: Palette.error.withOpacity(0)),
//             );
//           default:
//             throw Error();
//         }
//       },
//     );
//   }
// }

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
