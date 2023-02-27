import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/core/assets.dart';
import 'package:yotifiy/core/build_context_extension.dart';
import 'package:yotifiy/core/list_extension.dart';
import 'package:yotifiy/core/url_launch_handler.dart';
import 'package:yotifiy/playlist/playlist_model.dart';

class YFPlaylistDetailsPage extends StatelessWidget {
  final YFPlaylist playlist;
  final bool isEditMode;

  const YFPlaylistDetailsPage({
    super.key,
    required this.playlist,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: context.colorTheme.background1,
          size: 30,
        ),
      )),
      body: YFPlaylistDetailsBody(
        playlist: playlist,
      ),
    );
  }
}

class YFPlaylistDetailsBody extends StatelessWidget {
  final YFPlaylist playlist;
  final bool isImportView;

  const YFPlaylistDetailsBody({
    super.key,
    this.isImportView = false,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ['Title', 'Artist', 'Release Date'];

    return SingleChildScrollView(
      child: Column(
        children: [
          if (!isImportView) ...[
            _buildPlaylistInformation(context),
            Divider(
              thickness: context.spaceTheme.padding1,
              color: context.colorTheme.background2,
            ),
          ],
          if (isImportView)
            SizedBox(
              height: 30.h,
            ),
          Padding(
            padding: isImportView
                ? const EdgeInsets.all(0)
                : EdgeInsets.all(context.spaceTheme.padding2),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FractionColumnWidth(0.7),
                1: FractionColumnWidth(0.2),
                2: FractionColumnWidth(0.1),
              },
              children: [
                _getColumns(columns, context),
                ..._getRows(playlist.mediaItems, context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaylistInformation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.spaceTheme.padding5),
      child: Row(
        children: [
          SizedBox(
            height: 250.h,
            child: Image.network(
              playlist.thumbnailURL,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Image.asset(
                YFAssets.defaultPlaylist,
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(playlist.name, style: context.textTheme.headline2),
                SizedBox(
                  child: Text(
                    playlist.description,
                    style: context.textTheme.body2,
                  ),
                ),
                _buildUrlLaunchButton(context),
              ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
            ),
          )
        ],
      ),
    );
  }

  TableRow _getColumns(
    List<String> columns,
    BuildContext context,
  ) {
    return TableRow(
        children: columns.map((String column) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            column,
            style: context.textTheme.headline2,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(
            thickness: context.spaceTheme.padding05,
            color: isImportView
                ? context.colorTheme.background1
                : context.colorTheme.background2,
          ),
        ],
      );
    }).toList());
  }

  List<TableRow> _getRows(List<YFMediaItem> songs, BuildContext context) {
    int counter = 0;
    return songs.map((e) {
      counter++;

      return TableRow(
        children: [
          InkWell(
            onTap: launchUrl(e.mediaURL),
            child: SizedBox(
              height: 100.h,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      counter.toString(),
                      style: context.textTheme.headline4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Image.network(
                      e.mediaImageURL,
                      errorBuilder: (_, __, ___) =>
                          Image.asset(YFAssets.defaultPlaylist),
                      fit: BoxFit.fitHeight,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        e.name,
                        style:
                            context.textTheme.body2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
                ),
              ),
            ),
          ),
          Text(
            e.owner,
            style: context.textTheme.body2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            e.publishDate,
            style: context.textTheme.body2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }).toList();
  }

  Widget _buildUrlLaunchButton(BuildContext context) {
    return InkWell(
      onTap: launchUrl(playlist.playlistURL),
      child: Container(
        width: 75.w,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5.w,
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            const Icon(Icons.video_library),
            SizedBox(
              width: 5.w,
            ),
            Text('Open in web', style: context.textTheme.body2),
          ],
        ),
      ),
    );
  }
}
