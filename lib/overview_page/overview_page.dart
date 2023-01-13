import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:yotifiy/core/theme/text.dart';

class YFOverviewPage extends StatefulWidget {
  const YFOverviewPage({super.key});

  @override
  State<YFOverviewPage> createState() => _YFOverviewPageState();
}

class _YFOverviewPageState extends State<YFOverviewPage> {
  final textTheme = YFTextTheme();

  @override
  void initState() {
    super.initState();
    DesktopWindow.setMinWindowSize(const Size(1600, 1200));
    DesktopWindow.setMaxWindowSize(const Size(2800, 2400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        _buildNavigationBar(context),
        _buildOverview(),
      ],
    ));
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Column(
      children: [
        Text('YOTIFY', style: textTheme.headline1),
        TextButton(
            onPressed: () => _navigateToPage(0),
            child: Text('Home', style: textTheme.body1))
      ],
    );
  }

  Widget _buildOverview() {
    return Container();
  }

  void _navigateToPage(int index) {}
}
