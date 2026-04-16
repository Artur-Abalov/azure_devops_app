import 'package:azure_devops/src/mixins/logger_mixin.dart';
import 'package:azure_devops/src/models/amazon/amazon_item.dart';
import 'package:azure_devops/src/services/amazon_service.dart';
import 'package:flutter/material.dart';

abstract interface class AdsService {
  bool get hasAmazonAds;
  Future<void> init();
  Future<void> showInterstitialAd({VoidCallback? onDismiss});
  void removeAds();
  void reactivateAds();
  Future<List<AmazonItem>> getNewAmazonAds();
}

class AdsServiceImpl with AppLogger implements AdsService {
  factory AdsServiceImpl() => _instance ??= AdsServiceImpl._internal();

  AdsServiceImpl._internal();

  static AdsServiceImpl? _instance;

  static const _tag = 'AdsService';

  bool _showAds = true;

  @override
  bool get hasAmazonAds => _hasAmazonAds;
  bool _hasAmazonAds = true;

  @override
  Future<void> init() {
    setTag(_tag);
    logDebug('initialized');
    return Future.value();
  }

  @override
  Future<void> showInterstitialAd({VoidCallback? onDismiss}) {
    onDismiss?.call();
    return Future.value();
  }

  @override
  void removeAds() {
    logDebug('Ads removed');
    _showAds = false;
  }

  @override
  void reactivateAds() {
    logDebug('Ads reactivated');
    _showAds = true;
  }

  @override
  Future<List<AmazonItem>> getNewAmazonAds() async {
    if (!_showAds) return [];
    if (!_hasAmazonAds) return [];

    final items = await AmazonService().getItems();
    if (items.isEmpty) {
      logDebug('No Amazon ads found');
      _hasAmazonAds = false;
    } else {
      _hasAmazonAds = true;
    }

    return items;
  }
}

class AdsServiceWidget extends InheritedWidget {
  const AdsServiceWidget({super.key, required super.child, required this.ads});

  final AdsService ads;

  static AdsServiceWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdsServiceWidget>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
