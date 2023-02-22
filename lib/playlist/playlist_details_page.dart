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
        isEditMode: isEditMode,
      ),
    );
  }
}

class YFPlaylistDetailsBody extends StatelessWidget {
  final YFPlaylist playlist;
  final bool isEditMode;

  const YFPlaylistDetailsBody({
    super.key,
    required this.playlist,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final columns = [
      'Title',
      'Artist',
      isEditMode ? 'Import Song' : 'Release Date'
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPlaylistInformation(context),
          Divider(
            thickness: context.spaceTheme.padding1,
            color: context.colorTheme.background2,
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsets.all(context.spaceTheme.padding1),
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  dataRowHeight: 100.h,
                  columnSpacing: context.spaceTheme.padding5,
                  columns: _getColumns(columns),
                  rows: _getRows(playlist.mediaItems, context),
                ),
              ),
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

  List<DataColumn> _getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(label: Text(column));
    }).toList();
  }

  List<DataRow> _getRows(List<YFMediaItem> songs, BuildContext context) {
    int counter = 0;
    return songs.map((e) {
      counter++;

      return DataRow(
        cells: [
          DataCell(
            SizedBox(
              width: 200.w,
              child: Row(
                children: [
                  Text(counter.toString(), style: context.textTheme.headline4),
                  Image.network(
                    e.mediaImageURL,
                    errorBuilder: (_, __, ___) =>
                        Image.asset(YFAssets.defaultPlaylist),
                    fit: BoxFit.fitHeight,
                  ),
                  Text(e.name, style: context.textTheme.body2),
                ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
              ),
            ),
          ),
          DataCell(Text(e.owner, style: context.textTheme.body2)),

          // TODO: Für die Checkboxen in der import settings page dann am besten eine eigene Klasse _DataRowItem
          // TODO: erstellen, damit darin dann das isSelected bool gesetzt werden kann. Anschließend muss die Liste
          // TODO: mit allen isSelected Items in einer Liste gespeichert werden, für die neue Playlist.
          DataCell(Text(e.publishDate, style: context.textTheme.body2)),
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
