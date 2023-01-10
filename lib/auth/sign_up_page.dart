import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yotifiy/auth/auth_cubit.dart';
import 'package:yotifiy/core/build_context_extension.dart';

const String YotifyLogo = 'assets/images/Yotify_Logo.png';

class YFSignUpPage extends StatefulWidget {
  const YFSignUpPage({super.key});

  @override
  State<YFSignUpPage> createState() => _YFSignUpPageState();
}

class _YFSignUpPageState extends State<YFSignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<YFAuthCubit, YFAuthState>(
      listener: _authCubitListener,
      child: Scaffold(
        backgroundColor: context.colorTheme.background2,
        body: _buildLoginCard(),
      ),
    );
  }

  Future<void> _authCubitListener(
    BuildContext context,
    YFAuthState state,
  ) async {
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
        width: 500,
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
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void onPressed() {
    context.read<YFAuthCubit>().loginSpotify(
          _usernameController.text,
          _passwordController.text,
        );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        YotifyLogo,
        height: 34,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildUsernameField(),
        _buildPasswordField(),
        context.spaceTheme.fixedSpace(8.h),
        _buildLoginButton(),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: 'password',
        hintStyle: TextStyle(color: context.colorTheme.hint),
      ),
      obscureText: true,
      cursorColor: Colors.white,
    );
  }

  Widget _buildUsernameField() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        hintText: 'username',
        hintStyle: TextStyle(color: context.colorTheme.hint),
      ),
      cursorColor: Colors.white,
    );
  }
}