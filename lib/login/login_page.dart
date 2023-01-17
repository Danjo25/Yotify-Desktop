import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/core/assets.dart';
import 'package:yotifiy/home_page/home_page.dart';
import 'package:yotifiy/login/youtube_auth_cubit.dart';
import 'package:yotifiy/core/build_context_extension.dart';

class YFLoginPage extends StatefulWidget {
  const YFLoginPage({super.key});

  @override
  State<YFLoginPage> createState() => _YFLoginPageState();
}

class _YFLoginPageState extends State<YFLoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<YFAuthCubit, YFYoutubeAuthState>(
      listener: _authCubitListener,
      child: Scaffold(
        backgroundColor: context.colorTheme.background2,
        body: _buildLoginCard(),
      ),
    );
  }

  Future<void> _authCubitListener(
    BuildContext context,
    YFYoutubeAuthState state,
  ) async {
    if (state.isAuthenticated) {
      Navigator.of(context).push(
        cupertino.CupertinoPageRoute(
          builder: (context) => const YFHomePage(),
        ),
      );
    }
    if (!state.hasError) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${state.error}'),
      backgroundColor: context.colorTheme.error,
    ));
  }

  Widget _buildLoginCard() {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.purple,
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Colors.red,
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            context.spaceTheme.fixedSpace(3.h),
            _buildLogo(),
            Padding(
              padding: EdgeInsets.all(context.spaceTheme.padding3),
              child: _buildLoginForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: 100,
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }

  void onPressed() => context.read<YFAuthCubit>().login();

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        YFAssets.yotifyLogo,
        height: 150,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        context.spaceTheme.fixedSpace(8.h),
        _buildLoginButton(),
      ],
    );
  }
}
