import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyChart extends StatefulWidget {
  final List data;
  const MyChart({Key? key, required this.data}) : super(key: key);

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      mainBarData(widget.data),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: y,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            // Theme.of(context).colorScheme.tertiary,
          ],
          transform: const GradientRotation(pi / 40),
        ),
        width: 10,
        backDrawRodData: BackgroundBarChartRodData(
            show: true, toY: 5, color: Theme.of(context).colorScheme.surface),
      ),
    ]);
  }

  List<BarChartGroupData> showingGroups(List data) => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, data[0]);
          case 1:
            return makeGroupData(1, data[1]);
          case 2:
            return makeGroupData(2, data[2]);
          case 3:
            return makeGroupData(3, data[3]);
          case 4:
            return makeGroupData(4, data[4]);
          case 5:
            return makeGroupData(5, data[5]);
          case 6:
            return makeGroupData(6, data[6]);
          case 7:
            return makeGroupData(7, data[7]);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData(List data) {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 38,
          getTitlesWidget: getTiles,
        )),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            getTitlesWidget: leftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      barGroups: showingGroups(data),
    );
  }

  Widget getTiles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Theme.of(context).colorScheme.outline,
      // fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;

    switch (value.toInt()) {
      case 0:
        text = Text('Mon', style: style);
        break;
      case 1:
        text = Text('Tue', style: style);
        break;
      case 2:
        text = Text('Wed', style: style);
        break;
      case 3:
        text = Text('Thr', style: style);
        break;
      case 4:
        text = Text('Fri', style: style);
        break;
      case 5:
        text = Text('Sat', style: style);
        break;
      case 6:
        text = Text('Sun', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 13,
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Theme.of(context).colorScheme.outline,
      // fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    // if (value == 0) {
    //   text = '';
    // } else if (value == 1) {
    //   text = '\$ 1K';
    // } else if (value == 2) {
    //   text = '\$ 2K';
    // } else if (value == 3) {
    //   text = '\$ 3K';
    // } else if (value == 4) {
    //   text = '\$ 4K';
    // } else if (value == 5) {
    //   text = '\$ 5K';
    // } else {
    //   return Container();
    // }
    text = '\$${value.toInt()}';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }
}
