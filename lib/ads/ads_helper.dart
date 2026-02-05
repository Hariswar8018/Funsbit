import 'dart:io';

class AdHelper {

  // =========================
  // GLOBAL TEST SWITCH
  // =========================
  // false = Test Ads
  // true  = Real Ads
  static bool isTest = false;


  // Banner
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIOS =
      'ca-app-pub-3940256099942544/2934735716';

  // Interstitial
  static const String _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIOS =
      'ca-app-pub-3940256099942544/4411468910';

  // Rewarded
  static const String _testRewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedIOS =
      'ca-app-pub-3940256099942544/1712485313';

  // Native
  static const String _testNativeAndroid =
      'ca-app-pub-3940256099942544/2247696110';
  static const String _testNativeIOS =
      'ca-app-pub-3940256099942544/3986624511';

  // =========================
  // REAL IDS (REPLACE THESE)
  // =========================

  // Banner (3)
  static const List<String> _realBannerAndroid = [
    'ca-app-pub-2814821888454521/3880198230',
    'ca-app-pub-2814821888454521/2408060811',
    'ca-app-pub-2814821888454521/2220358551',
  ];

  static const List<String> _realBannerIOS = [
    'ca-app-pub-xxxxxxxxx/banner1',
    'ca-app-pub-xxxxxxxxx/banner2',
    'ca-app-pub-xxxxxxxxx/banner3',
  ];

  // Interstitial (5)
  static const List<String> _realInterstitialAndroid = [
    'ca-app-pub-2814821888454521/5284779243',
    'ca-app-pub-2814821888454521/3971697572',
    'ca-app-pub-2814821888454521/9907276885',
    'ca-app-pub-2814821888454521/7296699066',
    'ca-app-pub-2814821888454521/5500401660',
  ];

  static const List<String> _realInterstitialIOS = [
    'ca-app-pub-xxxxxxxxx/inter1',
    'ca-app-pub-xxxxxxxxx/inter2',
    'ca-app-pub-xxxxxxxxx/inter3',
    'ca-app-pub-xxxxxxxxx/inter4',
    'ca-app-pub-xxxxxxxxx/inter5',
  ];

  // Rewarded (5)
  static const List<String> _realRewardedAndroid = [
    'ca-app-pub-2814821888454521/5257585431',
    'ca-app-pub-2814821888454521/7627871557',
    'ca-app-pub-2814821888454521/2874238321',
    'ca-app-pub-2814821888454521/1561156659',
    'ca-app-pub-2814821888454521/2874238321',
  ];

  static const List<String> _realRewardedIOS = [
    'ca-app-pub-xxxxxxxxx/reward1',
    'ca-app-pub-xxxxxxxxx/reward2',
    'ca-app-pub-xxxxxxxxx/reward3',
    'ca-app-pub-xxxxxxxxx/reward4',
    'ca-app-pub-xxxxxxxxx/reward5',
  ];

  // Native (2)
  static const List<String> _realNativeAndroid = [
    'ca-app-pub-2814821888454521/6314789884',
    'ca-app-pub-2814821888454521/5001708213',
  ];

  static const List<String> _realNativeIOS = [
    'ca-app-pub-xxxxxxxxx/native1',
    'ca-app-pub-xxxxxxxxx/native2',
  ];

  // =========================
  // BANNER IDS (3)
  // =========================

  static String getBanner(int index) {
    if (!isTest) {
      return Platform.isAndroid
          ? _testBannerAndroid
          : _testBannerIOS;
    }

    return Platform.isAndroid
        ? _realBannerAndroid[index % 3]
        : _realBannerIOS[index % 3];
  }


  static String getInterstitial(int index) {
    if (!isTest) {
      return Platform.isAndroid
          ? _testInterstitialAndroid
          : _testInterstitialIOS;
    }

    return Platform.isAndroid
        ? _realInterstitialAndroid[index % 5]
        : _realInterstitialIOS[index % 5];
  }

  // =========================
  // REWARDED IDS (5)
  // =========================

  static String getRewarded(int index) {
    if (!isTest) {
      return Platform.isAndroid
          ? _testRewardedAndroid
          : _testRewardedIOS;
    }

    return Platform.isAndroid
        ? _realRewardedAndroid[index % 5]
        : _realRewardedIOS[index % 5];
  }


  static String getNative(int index) {
    if (!isTest) {
      return Platform.isAndroid
          ? _testNativeAndroid
          : _testNativeIOS;
    }

    return Platform.isAndroid
        ? _realNativeAndroid[index % 2]
        : _realNativeIOS[index % 2];
  }
}
