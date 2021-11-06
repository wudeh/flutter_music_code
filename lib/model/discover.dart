import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class Discover {
  Discover({
    this.code,
    this.data,
    this.message,
  });

  factory Discover.fromJson(Map<String, dynamic> jsonRes) => Discover(
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

  Discover clone() => Discover.fromJson(
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
          blocks.add(Blocks.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Data(
      cursor: asT<Object?>(jsonRes['cursor']),
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

  Object? cursor;
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
          banners.add(Banners.fromJson(asT<Map<String, dynamic>>(item)!));
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
        song: jsonRes['song'] == null
            ? null
            : Song.fromJson(asT<Map<String, dynamic>>(jsonRes['song'])!),
        targetId: asT<int?>(jsonRes['targetId']),
        showAdTag: asT<bool?>(jsonRes['showAdTag']),
        adSource: asT<Object?>(jsonRes['adSource']),
        showContext: asT<Object?>(jsonRes['showContext']),
        targetType: asT<int?>(jsonRes['targetType']),
        typeTitle: asT<String?>(jsonRes['typeTitle']),
        url: asT<Object?>(jsonRes['url']),
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
  Song? song;
  int? targetId;
  bool? showAdTag;
  Object? adSource;
  Object? showContext;
  int? targetType;
  String? typeTitle;
  Object? url;
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

class Song {
  Song({
    this.name,
    this.id,
    this.pst,
    this.t,
    this.ar,
    this.alia,
    this.pop,
    this.st,
    this.rt,
    this.fee,
    this.v,
    this.crbt,
    this.cf,
    this.al,
    this.dt,
    this.h,
    this.m,
    this.l,
    this.a,
    this.cd,
    this.no,
    this.rtUrl,
    this.ftype,
    this.rtUrls,
    this.djId,
    this.copyright,
    this.sId,
    this.mark,
    this.originCoverType,
    this.originSongSimpleData,
    this.single,
    this.noCopyrightRcmd,
    this.mst,
    this.cp,
    this.mv,
    this.rtype,
    this.rurl,
    this.publishTime,
    this.videoInfo,
  });

  factory Song.fromJson(Map<String, dynamic> jsonRes) {
    final List<Ar>? ar = jsonRes['ar'] is List ? <Ar>[] : null;
    if (ar != null) {
      for (final dynamic item in jsonRes['ar']!) {
        if (item != null) {
          ar.add(Ar.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<Object>? alia = jsonRes['alia'] is List ? <Object>[] : null;
    if (alia != null) {
      for (final dynamic item in jsonRes['alia']!) {
        if (item != null) {
          alia.add(asT<Object>(item)!);
        }
      }
    }

    final List<Object>? rtUrls = jsonRes['rtUrls'] is List ? <Object>[] : null;
    if (rtUrls != null) {
      for (final dynamic item in jsonRes['rtUrls']!) {
        if (item != null) {
          rtUrls.add(asT<Object>(item)!);
        }
      }
    }
    return Song(
      name: asT<String?>(jsonRes['name']),
      id: asT<int?>(jsonRes['id']),
      pst: asT<int?>(jsonRes['pst']),
      t: asT<int?>(jsonRes['t']),
      ar: ar,
      alia: alia,
      pop: asT<int?>(jsonRes['pop']),
      st: asT<int?>(jsonRes['st']),
      rt: asT<String?>(jsonRes['rt']),
      fee: asT<int?>(jsonRes['fee']),
      v: asT<int?>(jsonRes['v']),
      crbt: asT<Object?>(jsonRes['crbt']),
      cf: asT<String?>(jsonRes['cf']),
      al: jsonRes['al'] == null
          ? null
          : Al.fromJson(asT<Map<String, dynamic>>(jsonRes['al'])!),
      dt: asT<int?>(jsonRes['dt']),
      h: jsonRes['h'] == null
          ? null
          : H.fromJson(asT<Map<String, dynamic>>(jsonRes['h'])!),
      m: jsonRes['m'] == null
          ? null
          : M.fromJson(asT<Map<String, dynamic>>(jsonRes['m'])!),
      l: jsonRes['l'] == null
          ? null
          : L.fromJson(asT<Map<String, dynamic>>(jsonRes['l'])!),
      a: asT<Object?>(jsonRes['a']),
      cd: asT<String?>(jsonRes['cd']),
      no: asT<int?>(jsonRes['no']),
      rtUrl: asT<Object?>(jsonRes['rtUrl']),
      ftype: asT<int?>(jsonRes['ftype']),
      rtUrls: rtUrls,
      djId: asT<int?>(jsonRes['djId']),
      copyright: asT<int?>(jsonRes['copyright']),
      sId: asT<int?>(jsonRes['s_id']),
      mark: asT<int?>(jsonRes['mark']),
      originCoverType: asT<int?>(jsonRes['originCoverType']),
      originSongSimpleData: asT<Object?>(jsonRes['originSongSimpleData']),
      single: asT<int?>(jsonRes['single']),
      noCopyrightRcmd: asT<Object?>(jsonRes['noCopyrightRcmd']),
      mst: asT<int?>(jsonRes['mst']),
      cp: asT<int?>(jsonRes['cp']),
      mv: asT<int?>(jsonRes['mv']),
      rtype: asT<int?>(jsonRes['rtype']),
      rurl: asT<Object?>(jsonRes['rurl']),
      publishTime: asT<int?>(jsonRes['publishTime']),
      videoInfo: jsonRes['videoInfo'] == null
          ? null
          : VideoInfo.fromJson(
              asT<Map<String, dynamic>>(jsonRes['videoInfo'])!),
    );
  }

  String? name;
  int? id;
  int? pst;
  int? t;
  List<Ar>? ar;
  List<Object>? alia;
  int? pop;
  int? st;
  String? rt;
  int? fee;
  int? v;
  Object? crbt;
  String? cf;
  Al? al;
  int? dt;
  H? h;
  M? m;
  L? l;
  Object? a;
  String? cd;
  int? no;
  Object? rtUrl;
  int? ftype;
  List<Object>? rtUrls;
  int? djId;
  int? copyright;
  int? sId;
  int? mark;
  int? originCoverType;
  Object? originSongSimpleData;
  int? single;
  Object? noCopyrightRcmd;
  int? mst;
  int? cp;
  int? mv;
  int? rtype;
  Object? rurl;
  int? publishTime;
  VideoInfo? videoInfo;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'pst': pst,
        't': t,
        'ar': ar,
        'alia': alia,
        'pop': pop,
        'st': st,
        'rt': rt,
        'fee': fee,
        'v': v,
        'crbt': crbt,
        'cf': cf,
        'al': al,
        'dt': dt,
        'h': h,
        'm': m,
        'l': l,
        'a': a,
        'cd': cd,
        'no': no,
        'rtUrl': rtUrl,
        'ftype': ftype,
        'rtUrls': rtUrls,
        'djId': djId,
        'copyright': copyright,
        's_id': sId,
        'mark': mark,
        'originCoverType': originCoverType,
        'originSongSimpleData': originSongSimpleData,
        'single': single,
        'noCopyrightRcmd': noCopyrightRcmd,
        'mst': mst,
        'cp': cp,
        'mv': mv,
        'rtype': rtype,
        'rurl': rurl,
        'publishTime': publishTime,
        'videoInfo': videoInfo,
      };

  Song clone() =>
      Song.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Ar {
  Ar({
    this.id,
    this.name,
    this.tns,
    this.alias,
  });

  factory Ar.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? tns = jsonRes['tns'] is List ? <Object>[] : null;
    if (tns != null) {
      for (final dynamic item in jsonRes['tns']!) {
        if (item != null) {
          tns.add(asT<Object>(item)!);
        }
      }
    }

    final List<Object>? alias = jsonRes['alias'] is List ? <Object>[] : null;
    if (alias != null) {
      for (final dynamic item in jsonRes['alias']!) {
        if (item != null) {
          alias.add(asT<Object>(item)!);
        }
      }
    }
    return Ar(
      id: asT<int?>(jsonRes['id']),
      name: asT<String?>(jsonRes['name']),
      tns: tns,
      alias: alias,
    );
  }

  int? id;
  String? name;
  List<Object>? tns;
  List<Object>? alias;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'tns': tns,
        'alias': alias,
      };

  Ar clone() =>
      Ar.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Al {
  Al({
    this.id,
    this.name,
    this.picUrl,
    this.tns,
    this.picStr,
    this.pic,
  });

  factory Al.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? tns = jsonRes['tns'] is List ? <Object>[] : null;
    if (tns != null) {
      for (final dynamic item in jsonRes['tns']!) {
        if (item != null) {
          tns.add(asT<Object>(item)!);
        }
      }
    }
    return Al(
      id: asT<int?>(jsonRes['id']),
      name: asT<String?>(jsonRes['name']),
      picUrl: asT<String?>(jsonRes['picUrl']),
      tns: tns,
      picStr: asT<String?>(jsonRes['pic_str']),
      pic: asT<int?>(jsonRes['pic']),
    );
  }

  int? id;
  String? name;
  String? picUrl;
  List<Object>? tns;
  String? picStr;
  int? pic;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'picUrl': picUrl,
        'tns': tns,
        'pic_str': picStr,
        'pic': pic,
      };

  Al clone() =>
      Al.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class H {
  H({
    this.br,
    this.fid,
    this.size,
    this.vd,
  });

  factory H.fromJson(Map<String, dynamic> jsonRes) => H(
        br: asT<int?>(jsonRes['br']),
        fid: asT<int?>(jsonRes['fid']),
        size: asT<int?>(jsonRes['size']),
        vd: asT<int?>(jsonRes['vd']),
      );

  int? br;
  int? fid;
  int? size;
  int? vd;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'br': br,
        'fid': fid,
        'size': size,
        'vd': vd,
      };

  H clone() =>
      H.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class M {
  M({
    this.br,
    this.fid,
    this.size,
    this.vd,
  });

  factory M.fromJson(Map<String, dynamic> jsonRes) => M(
        br: asT<int?>(jsonRes['br']),
        fid: asT<int?>(jsonRes['fid']),
        size: asT<int?>(jsonRes['size']),
        vd: asT<int?>(jsonRes['vd']),
      );

  int? br;
  int? fid;
  int? size;
  int? vd;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'br': br,
        'fid': fid,
        'size': size,
        'vd': vd,
      };

  M clone() =>
      M.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class L {
  L({
    this.br,
    this.fid,
    this.size,
    this.vd,
  });

  factory L.fromJson(Map<String, dynamic> jsonRes) => L(
        br: asT<int?>(jsonRes['br']),
        fid: asT<int?>(jsonRes['fid']),
        size: asT<int?>(jsonRes['size']),
        vd: asT<int?>(jsonRes['vd']),
      );

  int? br;
  int? fid;
  int? size;
  int? vd;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'br': br,
        'fid': fid,
        'size': size,
        'vd': vd,
      };

  L clone() =>
      L.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class VideoInfo {
  VideoInfo({
    this.moreThanOne,
    this.video,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> jsonRes) => VideoInfo(
        moreThanOne: asT<bool?>(jsonRes['moreThanOne']),
        video: jsonRes['video'] == null
            ? null
            : Video.fromJson(asT<Map<String, dynamic>>(jsonRes['video'])!),
      );

  bool? moreThanOne;
  Video? video;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'moreThanOne': moreThanOne,
        'video': video,
      };

  VideoInfo clone() => VideoInfo.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Video {
  Video({
    this.vid,
    this.type,
    this.title,
    this.playTime,
    this.coverUrl,
    this.publishTime,
    this.artists,
    this.alias,
  });

  factory Video.fromJson(Map<String, dynamic> jsonRes) => Video(
        vid: asT<String?>(jsonRes['vid']),
        type: asT<int?>(jsonRes['type']),
        title: asT<String?>(jsonRes['title']),
        playTime: asT<int?>(jsonRes['playTime']),
        coverUrl: asT<String?>(jsonRes['coverUrl']),
        publishTime: asT<int?>(jsonRes['publishTime']),
        artists: asT<Object?>(jsonRes['artists']),
        alias: asT<Object?>(jsonRes['alias']),
      );

  String? vid;
  int? type;
  String? title;
  int? playTime;
  String? coverUrl;
  int? publishTime;
  Object? artists;
  Object? alias;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'vid': vid,
        'type': type,
        'title': title,
        'playTime': playTime,
        'coverUrl': coverUrl,
        'publishTime': publishTime,
        'artists': artists,
        'alias': alias,
      };

  Video clone() =>
      Video.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
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
  });

  factory PageConfig.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? abtest = jsonRes['abtest'] is List ? <String>[] : null;
    if (abtest != null) {
      for (final dynamic item in jsonRes['abtest']!) {
        if (item != null) {
          abtest.add(asT<String>(item)!);
        }
      }
    }

    final List<String>? songLabelMarkPriority =
        jsonRes['songLabelMarkPriority'] is List ? <String>[] : null;
    if (songLabelMarkPriority != null) {
      for (final dynamic item in jsonRes['songLabelMarkPriority']!) {
        if (item != null) {
          songLabelMarkPriority.add(asT<String>(item)!);
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
          toastList.add(asT<Object>(item)!);
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
