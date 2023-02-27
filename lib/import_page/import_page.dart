import 'package:flutter/cupertino.dart' as cupertino;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/core/assets.dart';
import 'package:yotifiy/core/build_context_extension.dart';
import 'package:yotifiy/core/list_extension.dart';
import 'package:yotifiy/core/url_launch_handler.dart';
import 'package:yotifiy/import_page/import_playlist_cubit.dart';
import 'package:yotifiy/playlist/playlist_details_page.dart';
import 'package:yotifiy/playlist/playlist_model.dart';

class YFImportPage extends StatefulWidget {
  const YFImportPage({super.key});

  @override
  State<YFImportPage> createState() => _YFImportPageState();
}

class _YFImportPageState extends State<YFImportPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YFImportPlaylistCubit, YFImportPlaylistState>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 30,
          child: Scaffold(
            backgroundColor: context.colorTheme.background2,
            body: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Paste spotify playlist link here",
                  ),
                  onSubmitted: (String url) {
                    context.read<YFImportPlaylistCubit>().createPlaylist(url);
                  },
                ),
                state.isLoading
                    ? const Expanded(
                        child: Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : state.data != null
                        ? _buildPlaylistInformation(context, state.data!)
                        : Container()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaylistInformation(BuildContext context, YFPlaylist playlist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Result:', style: context.textTheme.headline1),
        SizedBox(
          height: 10.h,
        ),
        Container(
          color: context.colorTheme.background4,
          child: Padding(
            padding: EdgeInsets.all(context.spaceTheme.padding5),
            child: Row(
              children: [
                SizedBox(
                  height: 200.h,
                  child: Image.network(
                    playlist.thumbnailURL,
                    fit: BoxFit.fitHeight,
                    errorBuilder: (_, __, ___) => Image.asset(
                      YFAssets.defaultPlaylist,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
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
                      _ImportPageButton(
                          text: 'Open in Web',
                          onPressed: launchUrl(playlist.playlistURL)),
                      _ImportPageButton(
                        text: 'Import Playlist',
                        onPressed: () => setState(() {
                          context
                              .read<YFImportPlaylistCubit>()
                              .importPlaylist(playlist);
                        }),
                      ),
                      _ImportPageButton(
                        text: 'Edit Playlist and Import',
                        onPressed: () => Navigator.of(context).push(
                          cupertino.CupertinoPageRoute(
                            builder: (context) => YFPlaylistDetailsPage(
                                playlist: playlist, isEditMode: true),
                          ),
                        ),
                      )
                    ]..addSeparator(context.spaceTheme.fixedSpace(2.h)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImportPageButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _ImportPageButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.all(context.spaceTheme.padding3),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5.w,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        child: Row(
          children: [
            const Icon(Icons.video_library),
            SizedBox(
              width: 5.w,
            ),
            Text(text, style: context.textTheme.body2),
          ],
        ),
      ),
    );
  }
}
