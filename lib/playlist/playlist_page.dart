import 'package:flutter/cupertino.dart' as cupertino;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/core/assets.dart';
import 'package:yotifiy/core/build_context_extension.dart';
import 'package:yotifiy/core/list_extension.dart';
import 'package:yotifiy/playlist/playlist_cubit.dart';
import 'package:yotifiy/playlist/playlist_model.dart';
import 'package:yotifiy/playlist/playlist_details_page.dart';

class YFPlaylistPage extends StatefulWidget {
  const YFPlaylistPage({super.key});

  @override
  State<YFPlaylistPage> createState() => _YFPlaylistPageState();
}

class _YFPlaylistPageState extends State<YFPlaylistPage> {
  @override
  void initState() {
    super.initState();

    context.read<YFPlaylistCubit>().getYoutubePlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YFPlaylistCubit, YFPlaylistState>(
      builder: (context, state) {
        return state.isLoading
            ? Center(
                child: SizedBox(
                  width: 50.w,
                  height: 175.h,
                  child: const CircularProgressIndicator(),
                ),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height - 30,
                child: Padding(
                  padding: EdgeInsets.all(context.spaceTheme.padding4),
                  child: _buildList(state.data),
                ),
              );
      },
    );
  }

  Widget _buildList(List<YFPlaylist> playlists) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: context.spaceTheme.padding2,
      crossAxisSpacing: context.spaceTheme.padding2,
      children: [
        ...playlists.map(
          (e) => YFPlaylistItem(
            playlist: e,
            width: 300.h,
            height: 300.h,
            imageHeight: 150.h,
            boxDecoration: BoxDecoration(
              color: context.colorTheme.background1,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.colorTheme.background1,
                  context.colorTheme.background3,
                ],
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

class YFPlaylistItem extends StatelessWidget {
  final YFPlaylist playlist;
  final double width;
  final double height;
  final BoxDecoration boxDecoration;
  final double imageHeight;

  const YFPlaylistItem({
    super.key,
    required this.playlist,
    required this.width,
    required this.height,
    required this.boxDecoration,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        cupertino.CupertinoPageRoute(
          builder: (context) => YFPlaylistDetailsPage(
            playlist: playlist,
          ),
        ),
      ),
      child: Container(
        height: height,
        width: width,
        decoration: boxDecoration,
        child: Padding(
          padding: EdgeInsets.all(context.spaceTheme.padding2),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: imageHeight,
                    child: Image.network(
                      playlist.thumbnailURL,
                      fit: BoxFit.fitHeight,
                      errorBuilder: (_, __, ___) => Image.asset(
                        YFAssets.defaultPlaylist,
                      ),
                    ),
                  ),
                ),
                Text(playlist.name, style: context.textTheme.headline2),
                Text(
                  playlist.description,
                  style: context.textTheme.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('${playlist.mediaItems.length} Titel')
              ]..addSeparator(context.spaceTheme.fixedSpace(1.h)),
            ),
          ),
        ),
      ),
    );
  }
}
