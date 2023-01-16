import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/core/build_context_extension.dart';
import 'package:yotifiy/core/list_extension.dart';
import 'package:yotifiy/playlist/playlist_cubit.dart';
import 'package:yotifiy/playlist/playlist_model.dart';

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
            ? const Center(child: CircularProgressIndicator())
            : _buildList(state.data);
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

  const _YFPlaylistItem({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      color: context.colorTheme.background1,
      child: Padding(
        padding: EdgeInsets.all(context.spaceTheme.padding2),
        child: Column(
          children: [
            Container(
              child: Text('Hier Bild rein dann'),
              height: 200,
              width: 200,
              color: Colors.red,
            ),
            Text(playlist.name, style: context.textTheme.headline2),
            Text(
              playlist.description,
              style: context.textTheme.body2,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
        ),
      ),
    );
  }
}
