import 'package:flutter/cupertino.dart' as cupertino;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/core/build_context_extension.dart';
import 'package:yotifiy/core/list_extension.dart';
import 'package:yotifiy/home_page/home_page.dart';
import 'package:yotifiy/playlist/playlist_cubit.dart';
import 'package:yotifiy/playlist/playlist_model.dart';
import 'package:yotifiy/playlist/playlist_page.dart';

class YFOverviewPage extends StatefulWidget {
  final Function(PageName) onPageChange;

  const YFOverviewPage({super.key, required this.onPageChange});

  @override
  State<YFOverviewPage> createState() => _YFOverviewPageState();
}

class _YFOverviewPageState extends State<YFOverviewPage> {
  @override
  void initState() {
    super.initState();
    context.read<YFPlaylistCubit>().getYoutubePlaylists();
  }

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
        Row(
          children: [
            _buildPlaylistButton(context),
            _buildImportButton(context),
          ]..addSeparator(context.spaceTheme.fixedSpace(2.w)),
        ),
        Text(
          'Recent Playlists',
          style: context.textTheme.headline1,
        ),
        _buildRecentlyAddedPlaylists(context),
      ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
    );
  }

  Widget _buildPlaylistButton(BuildContext context) {
    return InkWell(
      onTap: () => widget.onPageChange(PageName.playlistPage),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[600]!, Colors.red[300]!],
          ),
        ),
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
      onTap: () => widget.onPageChange(PageName.importPage),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[500]!, Colors.green[300]!],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.spaceTheme.padding4),
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
    return BlocBuilder<YFPlaylistCubit, YFPlaylistState>(
      builder: (context, state) {
        return state.isLoading
            ? const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...state.data
                        .take(5)
                        .map((e) => _buildRecentlyAddedPlaylistItem(e))
                        .toList()
                  ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
                ),
              );
      },
    );
  }

  Widget _buildRecentlyAddedPlaylistItem(YFPlaylist playlist) {
    return YFPlaylistItem(
      playlist: playlist,
      width: 100.w,
      height: 260.h,
      imageHeight: 120.h,
      boxDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.pink[400]!, Colors.pink[200]!],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
