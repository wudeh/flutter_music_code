import 'dart:convert';
import 'dart:developer';

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

class FFConvert {
  FFConvert._();
  static T? Function<T extends Object?>(dynamic value) convert =
      <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

class DiscoverModel {
  DiscoverModel({
    this.code,
    this.data,
    this.message,
  });

  factory DiscoverModel.fromJson(Map<String, dynamic> jsonRes) => DiscoverModel(
        code: asT<int?>(jsonRes['code']),
        data: jsonRes['data'] == null
            ? null
            : Data.fromJson(asT<Map<String, dynamic>>(jsonRes['data'])!),
        message: asT<String?>(jsonRes['message']),
      );

  int? code;
  Data? data;
  String? message;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'data': data,
        'message': message,
      };

  DiscoverModel clone() => DiscoverModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Data {
  Data({
    this.cursor,
    this.blocks,
    this.hasMore,
    this.blockUUIDs,
    this.pageConfig,
    this.guideToast,
  });

  factory Data.fromJson(Map<String, dynamic> jsonRes) {
    final List<Blocks>? blocks = jsonRes['blocks'] is List ? <Blocks>[] : null;
    if (blocks != null) {
      for (final dynamic item in jsonRes['blocks']!) {
        if (item != null) {
          tryCatch(() {
            blocks.add(Blocks.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return Data(
      cursor: asT<String?>(jsonRes['cursor']),
      blocks: blocks,
      hasMore: asT<bool?>(jsonRes['hasMore']),
      blockUUIDs: asT<Object?>(jsonRes['blockUUIDs']),
      pageConfig: jsonRes['pageConfig'] == null
          ? null
          : PageConfig.fromJson(
              asT<Map<String, dynamic>>(jsonRes['pageConfig'])!),
      guideToast: jsonRes['guideToast'] == null
          ? null
          : GuideToast.fromJson(
              asT<Map<String, dynamic>>(jsonRes['guideToast'])!),
    );
  }

  String? cursor;
  List<Blocks>? blocks;
  bool? hasMore;
  Object? blockUUIDs;
  PageConfig? pageConfig;
  GuideToast? guideToast;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'cursor': cursor,
        'blocks': blocks,
        'hasMore': hasMore,
        'blockUUIDs': blockUUIDs,
        'pageConfig': pageConfig,
        'guideToast': guideToast,
      };

  Data clone() =>
      Data.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Blocks {
  Blocks({
    this.blockCode,
    this.showType,
    this.extInfo,
    this.canClose,
  });

  factory Blocks.fromJson(Map<String, dynamic> jsonRes) => Blocks(
        blockCode: asT<String?>(jsonRes['blockCode']),
        showType: asT<String?>(jsonRes['showType']),
        extInfo: jsonRes['extInfo'] == null
            ? null
            : ExtInfo.fromJson(asT<Map<String, dynamic>>(jsonRes['extInfo'])!),
        canClose: asT<bool?>(jsonRes['canClose']),
      );

  String? blockCode;
  String? showType;
  ExtInfo? extInfo;
  bool? canClose;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'blockCode': blockCode,
        'showType': showType,
        'extInfo': extInfo,
        'canClose': canClose,
      };

  Blocks clone() =>
      Blocks.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class ExtInfo {
  ExtInfo({
    this.banners,
  });

  factory ExtInfo.fromJson(Map<String, dynamic> jsonRes) {
    final List<Banners>? banners =
        jsonRes['banners'] is List ? <Banners>[] : null;
    if (banners != null) {
      for (final dynamic item in jsonRes['banners']!) {
        if (item != null) {
          tryCatch(() {
            banners.add(Banners.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return ExtInfo(
      banners: banners,
    );
  }

  List<Banners>? banners;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'banners': banners,
      };

  ExtInfo clone() => ExtInfo.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Banners {
  Banners({
    this.adLocation,
    this.monitorImpress,
    this.bannerId,
    this.extMonitor,
    this.pid,
    this.pic,
    this.program,
    this.video,
    this.adurlV2,
    this.adDispatchJson,
    this.dynamicVideoData,
    this.monitorType,
    this.adid,
    this.titleColor,
    this.requestId,
    this.exclusive,
    this.scm,
    this.event,
    this.alg,
    this.song,
    this.targetId,
    this.showAdTag,
    this.adSource,
    this.showContext,
    this.targetType,
    this.typeTitle,
    this.url,
    this.encodeId,
    this.extMonitorInfo,
    this.monitorClick,
    this.monitorImpressList,
    this.monitorBlackList,
    this.monitorClickList,
  });

  factory Banners.fromJson(Map<String, dynamic> jsonRes) => Banners(
        adLocation: asT<Object?>(jsonRes['adLocation']),
        monitorImpress: asT<Object?>(jsonRes['monitorImpress']),
        bannerId: asT<String?>(jsonRes['bannerId']),
        extMonitor: asT<Object?>(jsonRes['extMonitor']),
        pid: asT<Object?>(jsonRes['pid']),
        pic: asT<String?>(jsonRes['pic']),
        program: asT<Object?>(jsonRes['program']),
        video: asT<Object?>(jsonRes['video']),
        adurlV2: asT<Object?>(jsonRes['adurlV2']),
        adDispatchJson: asT<Object?>(jsonRes['adDispatchJson']),
        dynamicVideoData: asT<Object?>(jsonRes['dynamicVideoData']),
        monitorType: asT<Object?>(jsonRes['monitorType']),
        adid: asT<Object?>(jsonRes['adid']),
        titleColor: asT<String?>(jsonRes['titleColor']),
        requestId: asT<String?>(jsonRes['requestId']),
        exclusive: asT<bool?>(jsonRes['exclusive']),
        scm: asT<String?>(jsonRes['scm']),
        event: asT<Object?>(jsonRes['event']),
        alg: asT<Object?>(jsonRes['alg']),
        song: asT<Object?>(jsonRes['song']),
        targetId: asT<int?>(jsonRes['targetId']),
        showAdTag: asT<bool?>(jsonRes['showAdTag']),
        adSource: asT<Object?>(jsonRes['adSource']),
        showContext: asT<Object?>(jsonRes['showContext']),
        targetType: asT<int?>(jsonRes['targetType']),
        typeTitle: asT<String?>(jsonRes['typeTitle']),
        url: asT<String?>(jsonRes['url']),
        encodeId: asT<String?>(jsonRes['encodeId']),
        extMonitorInfo: asT<Object?>(jsonRes['extMonitorInfo']),
        monitorClick: asT<Object?>(jsonRes['monitorClick']),
        monitorImpressList: asT<Object?>(jsonRes['monitorImpressList']),
        monitorBlackList: asT<Object?>(jsonRes['monitorBlackList']),
        monitorClickList: asT<Object?>(jsonRes['monitorClickList']),
      );

  Object? adLocation;
  Object? monitorImpress;
  String? bannerId;
  Object? extMonitor;
  Object? pid;
  String? pic;
  Object? program;
  Object? video;
  Object? adurlV2;
  Object? adDispatchJson;
  Object? dynamicVideoData;
  Object? monitorType;
  Object? adid;
  String? titleColor;
  String? requestId;
  bool? exclusive;
  String? scm;
  Object? event;
  Object? alg;
  Object? song;
  int? targetId;
  bool? showAdTag;
  Object? adSource;
  Object? showContext;
  int? targetType;
  String? typeTitle;
  String? url;
  String? encodeId;
  Object? extMonitorInfo;
  Object? monitorClick;
  Object? monitorImpressList;
  Object? monitorBlackList;
  Object? monitorClickList;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'adLocation': adLocation,
        'monitorImpress': monitorImpress,
        'bannerId': bannerId,
        'extMonitor': extMonitor,
        'pid': pid,
        'pic': pic,
        'program': program,
        'video': video,
        'adurlV2': adurlV2,
        'adDispatchJson': adDispatchJson,
        'dynamicVideoData': dynamicVideoData,
        'monitorType': monitorType,
        'adid': adid,
        'titleColor': titleColor,
        'requestId': requestId,
        'exclusive': exclusive,
        'scm': scm,
        'event': event,
        'alg': alg,
        'song': song,
        'targetId': targetId,
        'showAdTag': showAdTag,
        'adSource': adSource,
        'showContext': showContext,
        'targetType': targetType,
        'typeTitle': typeTitle,
        'url': url,
        'encodeId': encodeId,
        'extMonitorInfo': extMonitorInfo,
        'monitorClick': monitorClick,
        'monitorImpressList': monitorImpressList,
        'monitorBlackList': monitorBlackList,
        'monitorClickList': monitorClickList,
      };

  Banners clone() => Banners.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class PageConfig {
  PageConfig({
    this.refreshToast,
    this.nodataToast,
    this.refreshInterval,
    this.title,
    this.fullscreen,
    this.abtest,
    this.songLabelMarkPriority,
    this.songLabelMarkLimit,
    this.homepageMode,
    this.showModeEntry,
    this.orderInfo,
  });

  factory PageConfig.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? abtest = jsonRes['abtest'] is List ? <String>[] : null;
    if (abtest != null) {
      for (final dynamic item in jsonRes['abtest']!) {
        if (item != null) {
          tryCatch(() {
            abtest.add(asT<String>(item)!);
          });
        }
      }
    }

    final List<String>? songLabelMarkPriority =
        jsonRes['songLabelMarkPriority'] is List ? <String>[] : null;
    if (songLabelMarkPriority != null) {
      for (final dynamic item in jsonRes['songLabelMarkPriority']!) {
        if (item != null) {
          tryCatch(() {
            songLabelMarkPriority.add(asT<String>(item)!);
          });
        }
      }
    }
    return PageConfig(
      refreshToast: asT<String?>(jsonRes['refreshToast']),
      nodataToast: asT<String?>(jsonRes['nodataToast']),
      refreshInterval: asT<int?>(jsonRes['refreshInterval']),
      title: asT<Object?>(jsonRes['title']),
      fullscreen: asT<bool?>(jsonRes['fullscreen']),
      abtest: abtest,
      songLabelMarkPriority: songLabelMarkPriority,
      songLabelMarkLimit: asT<int?>(jsonRes['songLabelMarkLimit']),
      homepageMode: asT<String?>(jsonRes['homepageMode']),
      showModeEntry: asT<bool?>(jsonRes['showModeEntry']),
      orderInfo: asT<String?>(jsonRes['orderInfo']),
    );
  }

  String? refreshToast;
  String? nodataToast;
  int? refreshInterval;
  Object? title;
  bool? fullscreen;
  List<String>? abtest;
  List<String>? songLabelMarkPriority;
  int? songLabelMarkLimit;
  String? homepageMode;
  bool? showModeEntry;
  String? orderInfo;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'refreshToast': refreshToast,
        'nodataToast': nodataToast,
        'refreshInterval': refreshInterval,
        'title': title,
        'fullscreen': fullscreen,
        'abtest': abtest,
        'songLabelMarkPriority': songLabelMarkPriority,
        'songLabelMarkLimit': songLabelMarkLimit,
        'homepageMode': homepageMode,
        'showModeEntry': showModeEntry,
        'orderInfo': orderInfo,
      };

  PageConfig clone() => PageConfig.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class GuideToast {
  GuideToast({
    this.hasGuideToast,
    this.toastList,
  });

  factory GuideToast.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? toastList =
        jsonRes['toastList'] is List ? <Object>[] : null;
    if (toastList != null) {
      for (final dynamic item in jsonRes['toastList']!) {
        if (item != null) {
          tryCatch(() {
            toastList.add(asT<Object>(item)!);
          });
        }
      }
    }
    return GuideToast(
      hasGuideToast: asT<bool?>(jsonRes['hasGuideToast']),
      toastList: toastList,
    );
  }

  bool? hasGuideToast;
  List<Object>? toastList;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'hasGuideToast': hasGuideToast,
        'toastList': toastList,
      };

  GuideToast clone() => GuideToast.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
