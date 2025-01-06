# flutter_max_ad

A new Flutter project.

## Getting Started

### Set Proguard

0.3.5 no topon
0.3.9 has topon
0.3.6 no topon no facebook

#### Android

Config max other platform
```dart
https://developers.applovin.com/en/android/preparing-mediated-networks/
```

Config topOn other platform
```dart
https://app.toponad.com/m/sdk/download
```

Open your AndroidManifest, add content in this file
```dart
  <uses-library
android:name="org.apache.http.legacy"
android:required="false" />
<meta-data
android:name="com.google.android.gms.ads.APPLICATION_ID"
android:value="ca-app-pub-3940256099942544~3347511713" />
<meta-data
android:name="com.google.android.gms.ads.AD_MANAGER_APP"
android:value="true" />
```

#### iOS

Open your Podfile, add content in target 'Runner' do

```dart
pod 'AppLovinMediationChartboostAdapter'
pod 'AppLovinMediationFyberAdapter'
pod 'AppLovinMediationGoogleAdManagerAdapter'
pod 'AppLovinMediationGoogleAdapter'
pod 'AppLovinMediationInMobiAdapter'
pod 'AppLovinMediationIronSourceAdapter'
pod 'AppLovinMediationVungleAdapter'
pod 'AppLovinMediationMintegralAdapter'
pod 'AppLovinMediationUnityAdsAdapter'
pod 'AppLovinMediationByteDanceAdapter'
pod 'AppLovinMediationFacebookAdapter'
```

Add content into your info.list

```dart
<key>CFBundleURLTypes</key>
<array>
<dict>
<key>CFBundleURLSchemes</key>
<array>
<string>fb[APP_ID]</string>
</array>
</dict>
</array>
<key>FacebookAppID</key>
<string>[APP_ID]</string>
<key>FacebookClientToken</key>
<string>[CLIENT_TOKEN]</string>
<key>FacebookDisplayName</key>
<string>[APP_NAME]</string>

<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~2558002522</string>
<key>SKAdNetworkItems</key>
<array>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>su67r6k2v3.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>cstr6suwn9.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>4fzdc2evr5.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>4pfyvq9l8r.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>2fnua5tdw4.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>ydx93a7ass.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>5a6flpkh64.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>p78axxw29g.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>v72qych5uu.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>ludvb6z3bs.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>cp8zw746q7.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>3sh42y64q3.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>c6k4g5qg8m.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>s39g8k73mm.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>3qy4746246.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>f38h382jlk.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>hs6bdukanm.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>v4nxqhlyqp.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>wzmmz9fp6w.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>yclnxrl5pm.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>t38b2kh725.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>7ug5zh24hu.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>gta9lk7p23.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>vutu7akeur.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>y5ghdn5j9k.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>n6fk4nfna4.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>v9wttpbfk9.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>n38lu8286q.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>47vhws6wlr.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>kbd757ywx3.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>9t245vhmpl.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>eh6m2bh4zr.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>a2p9lx4jpn.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>22mmun2rn5.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>4468km3ulz.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>2u9pt9hc89.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>8s468mfl3y.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>klf5c3l5u5.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>ppxm28t8ap.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>ecpz2srf59.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>uw77j35x4d.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>pwa73g5rt2.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>mlmmfzh3r3.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>578prtvx9j.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>4dzt52r2t5.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>e5fvkxwrpn.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>8c4e2ghe7u.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>zq492l623r.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>3rd42ekr43.skadnetwork</string>
</dict>
<dict>
<key>SKAdNetworkIdentifier</key>
<string>3qcr597p9d.skadnetwork</string>
</dict>
</array>
<key>NSUserNotificationsUsageDescription</key>
<string>Demo</string>
```
