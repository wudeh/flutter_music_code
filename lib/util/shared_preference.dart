import 'dart:async';

import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

/// A class that holds [Preference] objects for the common values that you want
/// to store in your app. This is *not* necessarily needed, but it makes your
/// code more neat.
///
/// (In a real app you'd want to use an [InheritedWidget] to pass this around).
class MyAppSettings {
  MyAppSettings(StreamingSharedPreferences preferences)
      : seachHistory =
            preferences.getStringList('seachHistory', defaultValue: []),
        colorIndex = preferences.getInt('colorIndex', defaultValue: 0),
        userInfo = preferences.getString('userInfo', defaultValue: "");

  final Preference<List<String>> seachHistory;
  final Preference<int> colorIndex;
  final Preference<String> userInfo;
}
