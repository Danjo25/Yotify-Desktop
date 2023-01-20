import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/core/build_context_extension.dart';
import 'package:yotifiy/core/list_extension.dart';
import 'package:yotifiy/home_page/home_page.dart';

class YFOverviewPage extends StatelessWidget {
  final Function(PageName) onPageChange;

  const YFOverviewPage({super.key, required this.onPageChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.spaceTheme.padding5 * 2),
        Text(
          'Overview',
          style: context.textTheme.headline1,
        ),
        SizedBox(height: context.spaceTheme.padding5),
        Row(
          children: [
            _buildPlaylistButton(context),
            SizedBox(
              width: context.spaceTheme.padding5,
            ),
            _buildImportButton(context)
          ],
        ),
        SizedBox(
          height: context.spaceTheme.padding5,
        ),
        Text('Recent Playlists', style: context.textTheme.headline1),
        SizedBox(
          height: context.spaceTheme.padding2,
        ),
        _buildRecentlyAddedPlaylists(context),
      ],
    );
  }

  Widget _buildPlaylistButton(BuildContext context) {
    return InkWell(
      onTap: () => onPageChange(PageName.playlistPage),
      child: Container(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(context.spaceTheme.padding4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Playlist',
                style: context.textTheme.headline1,
              ),
              Text(
                'View and manage all your YouTube playlists',
                style: context.textTheme.body2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImportButton(BuildContext context) {
    return InkWell(
      onTap: () => onPageChange(PageName.importPage),
      child: Container(
        color: Colors.green,
        child: Padding(
          padding:  EdgeInsets.all(context.spaceTheme.padding4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Import',
                style: context.textTheme.headline1,
              ),
              Text(
                'Import new Playlists from Spotify into your account',
                style: context.textTheme.body2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyAddedPlaylists(BuildContext context) {
    // TODO: Add correct recent playlists
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(width: 100.w, height: 100.h, color: Colors.pink),
          Container(width: 100.w, height: 100.h, color: Colors.pink),
          Container(width: 100.w, height: 100.h, color: Colors.pink),
          Container(width: 100.w, height: 100.h, color: Colors.pink),
        ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
      ),
    );
  }
}
