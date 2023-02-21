import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:yotifiy/playlist/playlist_model.dart';

class SearchCache {
  static Future<File> get _cacheFile async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}\\yf_search.json');
  }

  static Future<List<YFMediaItem>> getAsync(String query) async {
    final File cacheFile = await _cacheFile;

    Map<String, List<YFMediaItem>> cachedModels =
        await _loadCachedSearchResults(cacheFile);

    return cachedModels[query] ?? [];
  }

  static storeAsync(String query, List<YFMediaItem> mediaItem) async {
    final File cacheFile = await _cacheFile;

    Map<String, List<YFMediaItem>> cachedSearchResults =
        await _loadCachedSearchResults(cacheFile);

    cachedSearchResults[query] = mediaItem;

    cacheFile.writeAsString(jsonEncode(cachedSearchResults));
  }

  static Future<Map<String, List<YFMediaItem>>> _loadCachedSearchResults(
      File cacheFile) async {
    Map<String, List<YFMediaItem>> mediaItems = {};

    try {
      var data = jsonDecode(await cacheFile.readAsString());
      var dataMap = Map<String, dynamic>.from(data);

      for (MapEntry entry in dataMap.entries) {
        var query = entry.key;
        mediaItems[query] = [];

        for (var item in (entry.value as List<dynamic>)) {
          mediaItems[query]?.add(YFMediaItem.fromJson(item));
        }
      }
    } on Exception {
      print('Failed to load cached search results');

      return {};
    }

    return mediaItems;
  }
}
