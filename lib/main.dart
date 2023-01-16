import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:yotifiy/core/theme/color.dart';
import 'package:yotifiy/core/api/youtube_api.dart';
import 'package:yotifiy/login/youtube_auth_cubit.dart';
import 'package:yotifiy/login/login_page.dart';
import 'package:yotifiy/core/storage.dart';
import 'package:yotifiy/core/theme/data.dart';
import 'package:yotifiy/core/theme/widget.dart';
import 'package:yotifiy/playlist/playlist_cubit.dart';

Future<void> main() async {
  await dotenv.load();
  await DesktopWindow.setFullScreen(true);
  await DesktopWindow.setMinWindowSize(
    const Size(1000, 800),
  );
  runApp(const YFApp());
}

final _youtubeApi = YFYoutubeApi();
final _storage = YFStorage();
final _authCubit = YFAuthCubit(_youtubeApi);
final _playlistCubit = YFPlaylistCubit(_youtubeApi);

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
            designSize: const Size(375, 812),
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
