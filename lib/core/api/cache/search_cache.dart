import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:yotifiy/playlist/playlist_model.dart';

class SearchCache {
  static Future<File> get _cacheFile async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}\\yf_search.json');
  }

  static Future<YFMediaItem?> getAsync(String query) async {
    final File cacheFile = await _cacheFile;

    Map<String, YFMediaItem> cachedModels =
        await _loadCachedSearchResults(cacheFile);

    return cachedModels[query];
  }

  static storeAsync(String query, YFMediaItem mediaItem) async {
    final File cacheFile = await _cacheFile;

    Map<String, YFMediaItem> cachedSearchResults =
        await _loadCachedSearchResults(cacheFile);

    cachedSearchResults[query] = mediaItem;

    cacheFile.writeAsString(jsonEncode(cachedSearchResults));
  }

  static Future<Map<String, YFMediaItem>> _loadCachedSearchResults(
      File cacheFile) async {
    Map<String, YFMediaItem> mediaItems = {};

    try {
      var data = jsonDecode(await cacheFile.readAsString());
      var dataMap = Map<String, dynamic>.from(data);

      dataMap.forEach(
          (key, value) => mediaItems[key] = YFMediaItem.fromJson(value));
    } on Exception {
      print('Failed to load cached search results');

      return {};
    }

    return mediaItems;
  }
}
