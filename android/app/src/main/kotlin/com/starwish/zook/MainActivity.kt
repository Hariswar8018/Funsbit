package com.starwish.zook

import android.util.Log
import android.view.LayoutInflater
import android.widget.ImageView
import android.widget.TextView

import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register Native Ad Factory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "listTile",
            ListTileNativeAdFactory(layoutInflater)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        // Unregister Native Ad Factory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(
            flutterEngine,
            "listTile"
        )
    }
}

// ================================
// NATIVE AD FACTORY
// ================================

class ListTileNativeAdFactory(
    private val inflater: LayoutInflater
) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {

        val adView = inflater.inflate(
            R.layout.native_ad_listtile,
            null
        ) as NativeAdView

        // MEDIA
        val mediaView = adView.findViewById<MediaView>(R.id.ad_media)
        adView.mediaView = mediaView
        nativeAd.mediaContent?.let { mediaView.setMediaContent(it) }

        // HEADLINE
        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        headlineView.text = nativeAd.headline
        adView.headlineView = headlineView

        // BODY
        val bodyView = adView.findViewById<TextView>(R.id.ad_body)
        if (nativeAd.body != null) {
            bodyView.text = nativeAd.body
            bodyView.visibility = android.view.View.VISIBLE
            adView.bodyView = bodyView
        } else {
            bodyView.visibility = android.view.View.GONE
        }

        // ICON
        val iconView = adView.findViewById<ImageView>(R.id.ad_app_icon)
        if (nativeAd.icon != null) {
            iconView.setImageDrawable(nativeAd.icon!!.drawable)
            iconView.visibility = android.view.View.VISIBLE
            adView.iconView = iconView
        } else {
            iconView.visibility = android.view.View.GONE
        }

        // ADVERTISER
        val advertiserView = adView.findViewById<TextView>(R.id.ad_advertiser)
        if (nativeAd.advertiser != null) {
            advertiserView.text = nativeAd.advertiser
            advertiserView.visibility = android.view.View.VISIBLE
            adView.advertiserView = advertiserView
        } else {
            advertiserView.visibility = android.view.View.GONE
        }

        // FINAL BIND
        adView.setNativeAd(nativeAd)

        Log.d(
            "NATIVE_AD",
            "Has video: ${nativeAd.mediaContent?.hasVideoContent()}"
        )

        return adView
    }
}
