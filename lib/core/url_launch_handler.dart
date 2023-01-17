import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

VoidCallback launchUrl(String url) =>
    () => url_launcher.launchUrl(Uri.parse(url)).catchError((e, stack) {
          log('$e\n$stack');
        });
