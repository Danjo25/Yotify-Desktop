import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:yotifiy/core/api/playlist_importer.dart';
import 'package:yotifiy/core/api/spotify_api.dart';
import 'package:yotifiy/core/theme/color.dart';
import 'package:yotifiy/core/api/youtube_api.dart';
import 'package:yotifiy/import_page/import_playlist_cubit.dart';
import 'package:yotifiy/login/youtube_auth_cubit.dart';
import 'package:yotifiy/login/login_page.dart';
import 'package:yotifiy/core/storage.dart';
import 'package:yotifiy/core/theme/data.dart';
import 'package:yotifiy/core/theme/widget.dart';
import 'package:yotifiy/playlist/playlist_cubit.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const YFApp());

  const initialSize = Size(1200, 800);
  appWindow.minSize = const Size(800, 600);
  // appWindow.size = initialSize;
  appWindow.alignment = Alignment.center;
  DesktopWindow.setFullScreen(true);
  DesktopWindow.setMinWindowSize(initialSize);

  doWhenWindowReady(() {
    appWindow.show();
  });
}

final _youtubeApi = YFYoutubeApi();
final _spotifyApi = YFSpotifyApi();
final _storage = YFStorage();
final _playlistImporter = YFPlaylistImporter();
final _authCubit = YFAuthCubit(_youtubeApi);
final _playlistCubit = YFPlaylistCubit(_youtubeApi);
final _importPlaylistCubit = YFImportPlaylistCubit(
  _spotifyApi,
  _playlistImporter,
);

class YFApp extends StatefulWidget {
  static final mainRouteKey = GlobalKey<NavigatorState>();
  static final themeKey = GlobalKey<YFThemeState>();

  const YFApp({super.key});

  @override
  State<YFApp> createState() => _YFAppState();
}

class _YFAppState extends State<YFApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _authCubit),
        BlocProvider(create: (_) => _playlistCubit),
        BlocProvider(create: (_) => _importPlaylistCubit),
      ],
      child: MaterialApp(
        navigatorObservers: [
          SentryNavigatorObserver(),
        ],
        title: 'YOTIFY',
        theme: ThemeData.dark(),
        navigatorKey: YFApp.mainRouteKey,
        onGenerateRoute: (_) => MaterialWithModalsPageRoute(
          builder: (context) => ScreenUtilInit(
            builder: (context, _) => YFTheme(
              key: YFApp.themeKey,
              data: YFThemeData(
                colorTheme: YFColorTheme.dark,
              ),
              child: const YFLoginPage(),
            ),
          ),
        ),
      ),
    );
  }
}
