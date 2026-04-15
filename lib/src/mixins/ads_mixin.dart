import 'package:azure_devops/src/models/amazon/amazon_item.dart';
import 'package:azure_devops/src/services/ads_service.dart';
import 'package:flutter/widgets.dart';

mixin AdsMixin {
  List<AmazonItem> amazonAds = [];
  var _hasAmazonAds = false;

  Future<void> getNewNativeAds(AdsService ads) async {
    _hasAmazonAds = ads.hasAmazonAds;

    if (_hasAmazonAds) {
      final items = await _getNewAmazonAds(ads);
      if (items.isEmpty) {
        _hasAmazonAds = false;
      }
    }
  }

  Future<List<AmazonItem>> _getNewAmazonAds(AdsService ads) async {
    final newAmazonAds = await ads.getNewAmazonAds();
    return amazonAds = newAmazonAds.toList();
  }

  /// Whether to show a native ad at the given [index] inside [items] list.
  bool shouldShowNativeAd<T>(List<T> items, T item, int index) =>
      items.indexOf(item) % 5 == 4 && item != items.first && index < (_hasAmazonAds ? amazonAds.length : 0);

  Future<void> showInterstitialAd(AdsService ads, {VoidCallback? onDismiss}) async {
    await ads.showInterstitialAd(onDismiss: onDismiss);
  }
}
