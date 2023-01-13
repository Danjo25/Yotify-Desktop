import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:yotifiy/core/build_context_extension.dart';
import 'package:yotifiy/core/theme/color.dart';
import 'package:yotifiy/youtube_auth/youtube_api.dart';
import 'package:yotifiy/youtube_auth/youtube_auth_cubit.dart';
import 'package:yotifiy/youtube_auth/sign_up_page.dart';
import 'package:yotifiy/core/storage.dart';
import 'package:yotifiy/core/theme/data.dart';
import 'package:yotifiy/core/theme/widget.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const YFApp());
}

final _youtubeApi = YFYoutubeApi();
final _storage = YFStorage();
final _authCubit = YFAuthCubit(_youtubeApi);

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
              child: const YFSignUpPage(),
            ),
          ),
        ),
      ),
    );
  }
}
