import 'dart:math' as math;

import 'package:disney_voting/config/values.dart';
import 'package:disney_voting/ui/widgets/app_images.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../data/responses/responses.dart';

class Top5BarChart extends StatefulWidget {
  final List<DisneyCharacter> charList;
  const Top5BarChart({super.key, required this.charList});

  final shadowColor = const Color(0xFFCCCCCC);

  @override
  State<Top5BarChart> createState() => _Top5BarChartState();
}

class _Top5BarChartState extends State<Top5BarChart> {
  static List dataList = [
    const _BarData(Colors.green, 17, 0),
    const _BarData(Colors.pink, 10, 0),
    const _BarData(Colors.blue, 2.5, 0),
    const _BarData(Colors.orange, 2, 0),
    const _BarData(Colors.orange, 2, 0),
  ];

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: Sizes.s12,
          borderRadius: BorderRadius.zero,
        ),
        // BarChartRodData(
        //   toY: shadowValue,
        //   color: widget.shadowColor,
        //   width: 6,
        // ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AspectRatio(
        aspectRatio: 1.4,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            borderData: FlBorderData(
              show: true,
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                drawBelowEverything: true,
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      textAlign: TextAlign.left,
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: _IconWidget(
                        color: dataList[index].color,
                        isSelected: touchedGroupIndex == index,
                        imageUrl: widget.charList[index].image,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.shade300,
                strokeWidth: 1,
              ),
            ),
            barGroups: [
              _BarData(Colors.green,
                  widget.charList[0].vote!.toDouble(), 0),
              _BarData(Colors.green,
                  widget.charList[1].vote!.toDouble(), 0),
              _BarData(Colors.green,
                  widget.charList[2].vote!.toDouble(), 0),
              _BarData(Colors.green,
                  widget.charList[3].vote!.toDouble(), 0),
              _BarData(Colors.green,
                  widget.charList[4].vote!.toDouble(), 0),
            ].asMap().entries.map((e) {
              final index = e.key;
              final data = e.value;
              return generateBarGroup(
                index,
                data.color,
                data.value,
                data.shadowValue,
              );
            }).toList(),
            maxY: 20,
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipMargin: 0,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.toY.toString(),
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: rod.color,
                      fontSize: 18,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 12,
                        )
                      ],
                    ),
                  );
                },
              ),
              touchCallback: (event, response) {
                if (event.isInterestedForInteractions &&
                    response != null &&
                    response.spot != null) {
                  setState(() {
                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                  });
                } else {
                  setState(() {
                    touchedGroupIndex = -1;
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue);
  final Color color;
  final double value;
  final double shadowValue;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  final String? imageUrl;
  const _IconWidget(
      {required this.color, required this.isSelected, required this.imageUrl})
      : super(duration: const Duration(milliseconds: 300));
  final Color color;
  final bool isSelected;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      // child: Icon(
      //   widget.isSelected ? Icons.face_retouching_natural : Icons.face,
      //   color: widget.color,
      //   size: 28,
      // ),
      child: Container(
        child: CustomImage(
          imageUrl: widget.imageUrl!,
          height: widget.isSelected ? Sizes.s40 : Sizes.s30,
          width: widget.isSelected ? Sizes.s40 : Sizes.s30,
          radius: Sizes.s40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}
