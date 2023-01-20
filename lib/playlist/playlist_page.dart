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
                  child: CircularProgressIndicator(),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(context.spaceTheme.padding4),
                child: _buildList(state.data),
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
        ...playlists.map((e) => _YFPlaylistItem(playlist: e)),
      ],
    );
  }
}

class _YFPlaylistItem extends StatelessWidget {
  final YFPlaylist playlist;

  const _YFPlaylistItem({
    super.key,
    required this.playlist,
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
        height: 300.h,
        width: 300.w,
        decoration: BoxDecoration(
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
        child: Padding(
          padding: EdgeInsets.all(context.spaceTheme.padding2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 150.h,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text('${playlist.mediaItems.length} Titel')
            ]..addSeparator(context.spaceTheme.fixedSpace(1.h)),
          ),
        ),
      ),
    );
  }
}
