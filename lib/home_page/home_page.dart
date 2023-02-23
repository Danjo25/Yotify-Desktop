import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/core/build_context_extension.dart';
import 'package:yotifiy/core/theme/color.dart';
import 'package:yotifiy/core/theme/text.dart';
import 'package:yotifiy/import_page/import_page.dart';
import 'package:yotifiy/overview_page/overview_page.dart';
import 'package:yotifiy/playlist/playlist_page.dart';

import '../core/window_buttons.dart';

class YFHomePage extends StatefulWidget {
  const YFHomePage({super.key});

  @override
  State<YFHomePage> createState() => _YFHomePageState();
}

class _YFHomePageState extends State<YFHomePage> {
  final textTheme = YFTextTheme();
  PageName currentPage = PageName.overview;

  @override
  void initState() {
    super.initState();
    DesktopWindow.setMinWindowSize(const Size(1600, 1200));
    DesktopWindow.resetMaxWindowSize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorTheme.background2,
      body: Row(
        children: [
          Flexible(flex: 1, child: _buildNavigationBar(context)),
          context.spaceTheme.fixedSpace(2.w),
          Flexible(flex: 5, child: _buildCurrentPage()),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Container(
      color: YFColorTheme.black,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: WindowTitleBarBox(
              child: Row(children: [
                Expanded(child: MoveWindow()),
                WindowButtons(),
              ]),
            ),
          ),
          Text('YOTIFY', style: textTheme.headline1),
          context.spaceTheme.fixedSpace(2.h),
          _YFNavigationButton(
            text: 'Home',
            currentSelectedPage: currentPage,
            pageName: PageName.overview,
            onPressed: _changePage,
            icon: Icons.home,
          ),
          _YFNavigationButton(
            text: 'Playlists',
            currentSelectedPage: currentPage,
            pageName: PageName.playlistPage,
            onPressed: _changePage,
            icon: Icons.my_library_music_rounded,
          ),
          _YFNavigationButton(
            text: 'Import',
            currentSelectedPage: currentPage,
            pageName: PageName.importPage,
            onPressed: _changePage,
            icon: Icons.import_export_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    return _pages[currentPage] ??
        Text(
          'Something went wrong...',
          style: context.textTheme.headline2,
        );
  }

  void _changePage(PageName pageName) => setState(() {
        currentPage = pageName;
      });

  late final Map<PageName, Widget> _pages = {
    PageName.overview: YFOverviewPage(
      onPageChange: (pageName) => _changePage(pageName),
    ),
    PageName.playlistPage: const YFPlaylistPage(),
    PageName.importPage: const YFImportPage(),
  };
}

enum PageName {
  overview,
  playlistPage,
  importPage,
}

class _YFNavigationButton extends StatefulWidget {
  final String text;
  final PageName currentSelectedPage;
  final PageName pageName;
  final Function(PageName) onPressed;
  final IconData icon;

  const _YFNavigationButton({
    required this.text,
    required this.currentSelectedPage,
    required this.pageName,
    required this.onPressed,
    required this.icon,
  });

  bool get _isCurrentSelectedPage => currentSelectedPage == pageName;

  @override
  State<_YFNavigationButton> createState() => _YFNavigationButtonState();
}

class _YFNavigationButtonState extends State<_YFNavigationButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => widget.onPressed(widget.pageName),
        icon: Icon(
          widget.icon,
          size: 9.w,
          color: widget._isCurrentSelectedPage
              ? YFColorTheme.white
              : YFColorTheme.grey,
        ),
        label: Text(
          widget.text,
          style: context.textTheme.body1.copyWith(
            color: widget._isCurrentSelectedPage
                ? YFColorTheme.white
                : YFColorTheme.grey,
          ),
        ),
      ),
    );
    // return InkWell(
    //   onTap: () => widget.onPressed(widget.pageName),
    //   child: Container(
    //     alignment: Alignment.center,
    //     width: double.infinity,
    //     color: widget.currentSelectedPage == widget.pageName
    //         ? context.colorTheme.background1
    //         : null,
    //     child: Text(widget.text, style: context.textTheme.body1),
    //   ),
    // );
  }
}
