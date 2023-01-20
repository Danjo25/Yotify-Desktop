import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/core/assets.dart';
import 'package:yotifiy/core/build_context_extension.dart';
import 'package:yotifiy/core/list_extension.dart';
import 'package:yotifiy/core/url_launch_handler.dart';
import 'package:yotifiy/playlist/playlist_model.dart';

class YFPlaylistSongsPage extends StatelessWidget {
  final YFPlaylist playlist;

  YFPlaylistSongsPage({
    super.key,
    required this.playlist,
  });

  final columns = ['Title', 'Album', 'Duration'];

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
          color: context.colorTheme.hint,
          size: 30,
        ),
      )),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildPlaylistInformation(context),
              Divider(
                thickness: 10,
                color: context.colorTheme.background2,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    dataRowHeight: 100,
                    columnSpacing: 10,
                    columns: _getColumns(columns),
                    rows: _getRows(playlist.mediaItems, context),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: Image.network(
              playlist.thumbnailURL,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Image.asset(
                YFAssets.defaultPlaylist,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(playlist.name, style: context.textTheme.headline2),
              SizedBox(
                width: 1000,
                child: Text(
                  playlist.description,
                  style: context.textTheme.body2,
                ),
              ),
              _buildUrlLaunchButton(context),
            ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
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

      return DataRow(cells: [
        DataCell(
          Row(
            children: [
              Text(counter.toString(), style: context.textTheme.headline4),
              Image.network(
                e.mediaImageURL,
                errorBuilder: (_, __, ___) =>
                    Image.asset(YFAssets.defaultPlaylist),
                fit: BoxFit.fill,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.name, style: context.textTheme.body2),
                  Text('Künstlername hier', style: context.textTheme.body3)
                ],
              )
            ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
          ),
        ),
        DataCell(Text('Album hier', style: context.textTheme.body2)),
        DataCell(Text('Duration hier', style: context.textTheme.body2)),
      ]);
    }).toList();
  }

  Widget _buildUrlLaunchButton(BuildContext context) {
    return InkWell(
      onTap: launchUrl(playlist.playlistURL),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            const Icon(Icons.video_library),
            const SizedBox(
              width: 5,
            ),
            Text('Open in web', style: context.textTheme.body2),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader(BuildContext context) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('#', style: context.textTheme.headline4),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Titel', style: context.textTheme.headline4),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Album', style: context.textTheme.headline4),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.access_time),
        )
      ],
    );
  }
}

class _YFSongItem extends StatelessWidget {
  final YFMediaItem song;
  const _YFSongItem({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('#', style: context.textTheme.headline4),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Image.network(
                song.mediaImageURL,
                errorBuilder: (_, __, ___) =>
                    Image.asset(YFAssets.defaultPlaylist),
              ),
              Column(children: [
                Text('Titel', style: context.textTheme.headline4),
                Text('KünstlerName', style: context.textTheme.body3)
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Album', style: context.textTheme.headline4),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.access_time),
        )
      ],
    );
  }
}
