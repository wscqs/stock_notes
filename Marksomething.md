## 一些备注
dart pub global activate get_cli
getx,shell建页面。 get create page:chatdetail

flutter clean                      
flutter pub get
flutter build

## 包名 com.wlsp.carrotcards

## 打包flutter
https://docs.flutter.cn/deployment/android
https://www.jianshu.com/p/f13f4f996e2a
/Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin/keytool -genkey -v -keystore ~/carrot-keystore.jks -keyalg RSA \
-keysize 2048 -validity 10000 -alias carrot
密钥 carrotcarrot  后面问题1,2,3,4,5,6

storePassword=carrotcarrot
keyPassword=carrotcarrot
keyAlias=carrot
storeFile=/Users/cqs/carrot-keystore.jks
https://blog.csdn.net/wsyx768/article/details/136319899

## icon与splash
flutter pub run flutter_launcher_icons
dart run flutter_native_splash:create









## other
Flutter代码补全
option+j  https://juejin.cn/post/7296660227545104435


必备复习文章
https://blog.csdn.net/winni_a/category_12617274.html


页面刷新
启动白屏问题

内购
https://blog.csdn.net/panghaha12138/article/details/138534488


主题
https://ducafecat.com/blog/flutter-flex-color-scheme
https://ducafecat.com/blog/flutter-app-theme-switch

getX
https://developer.aliyun.com/article/1265115

一些封装
https://www.jianshu.com/p/52e870040636

对getx二次封装
https://juejin.cn/post/7390341683619381282


全平台分发（后面研究）
https://github.com/leanflutter/flutter_distributor

导航返回拦截
WillPopScope(
onWillPop: () async {
// your logic        
return false;
},
)
改
PopScope(
canPop: false,
onPopInvoked : (didPop){
// logic
},
)