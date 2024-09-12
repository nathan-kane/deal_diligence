import 'dart:io' show Platform;

class Secret {
    static const ANDROID_CLIENT_ID = "394692266013-e6a6302lhm59fuldi009203ah20tps32.apps.googleusercontent.com";
    static const WEB_CLIENT_ID = "394692266013-pj87pfid8p2l955nmua43sd6v3g5aqu3.apps.googleusercontent.com";
    static String getId() => Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.WEB_CLIENT_ID;
}