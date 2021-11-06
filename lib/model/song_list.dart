import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class SongList {
  SongList({
    this.code,
    this.relatedVideos,
    this.playlist,
    this.urls,
    this.privileges,
    this.sharedPrivilege,
  });

  factory SongList.fromJson(Map<String, dynamic> jsonRes) {
    final List<Privileges>? privileges =
        jsonRes['privileges'] is List ? <Privileges>[] : null;
    if (privileges != null) {
      for (final dynamic item in jsonRes['privileges']!) {
        if (item != null) {
          privileges.add(Privileges.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return SongList(
      code: asT<int?>(jsonRes['code']),
      relatedVideos: asT<Object?>(jsonRes['relatedVideos']),
      playlist: jsonRes['playlist'] == null
          ? null
          : Playlist.fromJson(asT<Map<String, dynamic>>(jsonRes['playlist'])!),
      urls: asT<Object?>(jsonRes['urls']),
      privileges: privileges,
      sharedPrivilege: asT<Object?>(jsonRes['sharedPrivilege']),
    );
  }

  int? code;
  Object? relatedVideos;
  Playlist? playlist;
  Object? urls;
  List<Privileges>? privileges;
  Object? sharedPrivilege;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'relatedVideos': relatedVideos,
        'playlist': playlist,
        'urls': urls,
        'privileges': privileges,
        'sharedPrivilege': sharedPrivilege,
      };

  SongList clone() => SongList
      .fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Playlist {
  Playlist({
    this.id,
    this.name,
    this.coverImgId,
    this.coverImgUrl,
    this.coverimgidStr,
    this.adType,
    this.userId,
    this.createTime,
    this.status,
    this.opRecommend,
    this.highQuality,
    this.newImported,
    this.updateTime,
    this.trackCount,
    this.specialType,
    this.privacy,
    this.trackUpdateTime,
    this.commentThreadId,
    this.playCount,
    this.trackNumberUpdateTime,
    this.subscribedCount,
    this.cloudTrackCount,
    this.ordered,
    this.description,
    this.tags,
    this.updateFrequency,
    this.backgroundCoverId,
    this.backgroundCoverUrl,
    this.titleImage,
    this.titleImageUrl,
    this.englishTitle,
    this.officialPlaylistType,
    this.subscribers,
    this.subscribed,
    this.creator,
    this.tracks,
    this.videoIds,
    this.videos,
    this.trackIds,
    this.shareCount,
    this.commentCount,
    this.remixVideo,
    this.sharedUsers,
    this.historySharedUsers,
  });

  factory Playlist.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? tags = jsonRes['tags'] is List ? <String>[] : null;
    if (tags != null) {
      for (final dynamic item in jsonRes['tags']!) {
        if (item != null) {
          tags.add(asT<String>(item)!);
        }
      }
    }

    final List<Subscribers>? subscribers =
        jsonRes['subscribers'] is List ? <Subscribers>[] : null;
    if (subscribers != null) {
      for (final dynamic item in jsonRes['subscribers']!) {
        if (item != null) {
          subscribers
              .add(Subscribers.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<Tracks>? tracks = jsonRes['tracks'] is List ? <Tracks>[] : null;
    if (tracks != null) {
      for (final dynamic item in jsonRes['tracks']!) {
        if (item != null) {
          tracks.add(Tracks.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<TrackIds>? trackIds =
        jsonRes['trackIds'] is List ? <TrackIds>[] : null;
    if (trackIds != null) {
      for (final dynamic item in jsonRes['trackIds']!) {
        if (item != null) {
          trackIds.add(TrackIds.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Playlist(
      id: asT<int?>(jsonRes['id']),
      name: asT<String?>(jsonRes['name']),
      coverImgId: asT<int?>(jsonRes['coverImgId']),
      coverImgUrl: asT<String?>(jsonRes['coverImgUrl']),
      coverimgidStr: asT<String?>(jsonRes['coverImgId_str']),
      adType: asT<int?>(jsonRes['adType']),
      userId: asT<int?>(jsonRes['userId']),
      createTime: asT<int?>(jsonRes['createTime']),
      status: asT<int?>(jsonRes['status']),
      opRecommend: asT<bool?>(jsonRes['opRecommend']),
      highQuality: asT<bool?>(jsonRes['highQuality']),
      newImported: asT<bool?>(jsonRes['newImported']),
      updateTime: asT<int?>(jsonRes['updateTime']),
      trackCount: asT<int?>(jsonRes['trackCount']),
      specialType: asT<int?>(jsonRes['specialType']),
      privacy: asT<int?>(jsonRes['privacy']),
      trackUpdateTime: asT<int?>(jsonRes['trackUpdateTime']),
      commentThreadId: asT<String?>(jsonRes['commentThreadId']),
      playCount: asT<int?>(jsonRes['playCount']),
      trackNumberUpdateTime: asT<int?>(jsonRes['trackNumberUpdateTime']),
      subscribedCount: asT<int?>(jsonRes['subscribedCount']),
      cloudTrackCount: asT<int?>(jsonRes['cloudTrackCount']),
      ordered: asT<bool?>(jsonRes['ordered']),
      description: asT<String?>(jsonRes['description']),
      tags: tags,
      updateFrequency: asT<Object?>(jsonRes['updateFrequency']),
      backgroundCoverId: asT<int?>(jsonRes['backgroundCoverId']),
      backgroundCoverUrl: asT<Object?>(jsonRes['backgroundCoverUrl']),
      titleImage: asT<int?>(jsonRes['titleImage']),
      titleImageUrl: asT<Object?>(jsonRes['titleImageUrl']),
      englishTitle: asT<Object?>(jsonRes['englishTitle']),
      officialPlaylistType: asT<Object?>(jsonRes['officialPlaylistType']),
      subscribers: subscribers,
      subscribed: asT<Object?>(jsonRes['subscribed']),
      creator: jsonRes['creator'] == null
          ? null
          : Creator.fromJson(asT<Map<String, dynamic>>(jsonRes['creator'])!),
      tracks: tracks,
      videoIds: asT<Object?>(jsonRes['videoIds']),
      videos: asT<Object?>(jsonRes['videos']),
      trackIds: trackIds,
      shareCount: asT<int?>(jsonRes['shareCount']),
      commentCount: asT<int?>(jsonRes['commentCount']),
      remixVideo: asT<Object?>(jsonRes['remixVideo']),
      sharedUsers: asT<Object?>(jsonRes['sharedUsers']),
      historySharedUsers: asT<Object?>(jsonRes['historySharedUsers']),
    );
  }

  int? id;
  String? name;
  int? coverImgId;
  String? coverImgUrl;
  String? coverimgidStr;
  int? adType;
  int? userId;
  int? createTime;
  int? status;
  bool? opRecommend;
  bool? highQuality;
  bool? newImported;
  int? updateTime;
  int? trackCount;
  int? specialType;
  int? privacy;
  int? trackUpdateTime;
  String? commentThreadId;
  int? playCount;
  int? trackNumberUpdateTime;
  int? subscribedCount;
  int? cloudTrackCount;
  bool? ordered;
  String? description;
  List<String>? tags;
  Object? updateFrequency;
  int? backgroundCoverId;
  Object? backgroundCoverUrl;
  int? titleImage;
  Object? titleImageUrl;
  Object? englishTitle;
  Object? officialPlaylistType;
  List<Subscribers>? subscribers;
  Object? subscribed;
  Creator? creator;
  List<Tracks>? tracks;
  Object? videoIds;
  Object? videos;
  List<TrackIds>? trackIds;
  int? shareCount;
  int? commentCount;
  Object? remixVideo;
  Object? sharedUsers;
  Object? historySharedUsers;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'coverImgId': coverImgId,
        'coverImgUrl': coverImgUrl,
        'coverImgId_str': coverimgidStr,
        'adType': adType,
        'userId': userId,
        'createTime': createTime,
        'status': status,
        'opRecommend': opRecommend,
        'highQuality': highQuality,
        'newImported': newImported,
        'updateTime': updateTime,
        'trackCount': trackCount,
        'specialType': specialType,
        'privacy': privacy,
        'trackUpdateTime': trackUpdateTime,
        'commentThreadId': commentThreadId,
        'playCount': playCount,
        'trackNumberUpdateTime': trackNumberUpdateTime,
        'subscribedCount': subscribedCount,
        'cloudTrackCount': cloudTrackCount,
        'ordered': ordered,
        'description': description,
        'tags': tags,
        'updateFrequency': updateFrequency,
        'backgroundCoverId': backgroundCoverId,
        'backgroundCoverUrl': backgroundCoverUrl,
        'titleImage': titleImage,
        'titleImageUrl': titleImageUrl,
        'englishTitle': englishTitle,
        'officialPlaylistType': officialPlaylistType,
        'subscribers': subscribers,
        'subscribed': subscribed,
        'creator': creator,
        'tracks': tracks,
        'videoIds': videoIds,
        'videos': videos,
        'trackIds': trackIds,
        'shareCount': shareCount,
        'commentCount': commentCount,
        'remixVideo': remixVideo,
        'sharedUsers': sharedUsers,
        'historySharedUsers': historySharedUsers,
      };

  Playlist clone() => Playlist.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Subscribers {
  Subscribers({
    this.defaultAvatar,
    this.province,
    this.authStatus,
    this.followed,
    this.avatarUrl,
    this.accountStatus,
    this.gender,
    this.city,
    this.birthday,
    this.userId,
    this.userType,
    this.nickname,
    this.signature,
    this.description,
    this.detailDescription,
    this.avatarImgId,
    this.backgroundImgId,
    this.backgroundUrl,
    this.authority,
    this.mutual,
    this.expertTags,
    this.experts,
    this.djStatus,
    this.vipType,
    this.remarkName,
    this.authenticationTypes,
    this.avatarDetail,
    this.avatarImgIdStr,
    this.backgroundImgIdStr,
    this.anchor,
    this.avatarimgidStr,
  });

  factory Subscribers.fromJson(Map<String, dynamic> jsonRes) => Subscribers(
        defaultAvatar: asT<bool?>(jsonRes['defaultAvatar']),
        province: asT<int?>(jsonRes['province']),
        authStatus: asT<int?>(jsonRes['authStatus']),
        followed: asT<bool?>(jsonRes['followed']),
        avatarUrl: asT<String?>(jsonRes['avatarUrl']),
        accountStatus: asT<int?>(jsonRes['accountStatus']),
        gender: asT<int?>(jsonRes['gender']),
        city: asT<int?>(jsonRes['city']),
        birthday: asT<int?>(jsonRes['birthday']),
        userId: asT<int?>(jsonRes['userId']),
        userType: asT<int?>(jsonRes['userType']),
        nickname: asT<String?>(jsonRes['nickname']),
        signature: asT<String?>(jsonRes['signature']),
        description: asT<String?>(jsonRes['description']),
        detailDescription: asT<String?>(jsonRes['detailDescription']),
        avatarImgId: asT<int?>(jsonRes['avatarImgId']),
        backgroundImgId: asT<int?>(jsonRes['backgroundImgId']),
        backgroundUrl: asT<String?>(jsonRes['backgroundUrl']),
        authority: asT<int?>(jsonRes['authority']),
        mutual: asT<bool?>(jsonRes['mutual']),
        expertTags: asT<Object?>(jsonRes['expertTags']),
        experts: asT<Object?>(jsonRes['experts']),
        djStatus: asT<int?>(jsonRes['djStatus']),
        vipType: asT<int?>(jsonRes['vipType']),
        remarkName: asT<Object?>(jsonRes['remarkName']),
        authenticationTypes: asT<int?>(jsonRes['authenticationTypes']),
        avatarDetail: asT<Object?>(jsonRes['avatarDetail']),
        avatarImgIdStr: asT<String?>(jsonRes['avatarImgIdStr']),
        backgroundImgIdStr: asT<String?>(jsonRes['backgroundImgIdStr']),
        anchor: asT<bool?>(jsonRes['anchor']),
        avatarimgidStr: asT<String?>(jsonRes['avatarImgId_str']),
      );

  bool? defaultAvatar;
  int? province;
  int? authStatus;
  bool? followed;
  String? avatarUrl;
  int? accountStatus;
  int? gender;
  int? city;
  int? birthday;
  int? userId;
  int? userType;
  String? nickname;
  String? signature;
  String? description;
  String? detailDescription;
  int? avatarImgId;
  int? backgroundImgId;
  String? backgroundUrl;
  int? authority;
  bool? mutual;
  Object? expertTags;
  Object? experts;
  int? djStatus;
  int? vipType;
  Object? remarkName;
  int? authenticationTypes;
  Object? avatarDetail;
  String? avatarImgIdStr;
  String? backgroundImgIdStr;
  bool? anchor;
  String? avatarimgidStr;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'defaultAvatar': defaultAvatar,
        'province': province,
        'authStatus': authStatus,
        'followed': followed,
        'avatarUrl': avatarUrl,
        'accountStatus': accountStatus,
        'gender': gender,
        'city': city,
        'birthday': birthday,
        'userId': userId,
        'userType': userType,
        'nickname': nickname,
        'signature': signature,
        'description': description,
        'detailDescription': detailDescription,
        'avatarImgId': avatarImgId,
        'backgroundImgId': backgroundImgId,
        'backgroundUrl': backgroundUrl,
        'authority': authority,
        'mutual': mutual,
        'expertTags': expertTags,
        'experts': experts,
        'djStatus': djStatus,
        'vipType': vipType,
        'remarkName': remarkName,
        'authenticationTypes': authenticationTypes,
        'avatarDetail': avatarDetail,
        'avatarImgIdStr': avatarImgIdStr,
        'backgroundImgIdStr': backgroundImgIdStr,
        'anchor': anchor,
        'avatarImgId_str': avatarimgidStr,
      };

  Subscribers clone() => Subscribers.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Creator {
  Creator({
    this.defaultAvatar,
    this.province,
    this.authStatus,
    this.followed,
    this.avatarUrl,
    this.accountStatus,
    this.gender,
    this.city,
    this.birthday,
    this.userId,
    this.userType,
    this.nickname,
    this.signature,
    this.description,
    this.detailDescription,
    this.avatarImgId,
    this.backgroundImgId,
    this.backgroundUrl,
    this.authority,
    this.mutual,
    this.expertTags,
    this.experts,
    this.djStatus,
    this.vipType,
    this.remarkName,
    this.authenticationTypes,
    this.avatarDetail,
    this.avatarImgIdStr,
    this.backgroundImgIdStr,
    this.anchor,
    this.avatarimgidStr,
  });

  factory Creator.fromJson(Map<String, dynamic> jsonRes) => Creator(
        defaultAvatar: asT<bool?>(jsonRes['defaultAvatar']),
        province: asT<int?>(jsonRes['province']),
        authStatus: asT<int?>(jsonRes['authStatus']),
        followed: asT<bool?>(jsonRes['followed']),
        avatarUrl: asT<String?>(jsonRes['avatarUrl']),
        accountStatus: asT<int?>(jsonRes['accountStatus']),
        gender: asT<int?>(jsonRes['gender']),
        city: asT<int?>(jsonRes['city']),
        birthday: asT<int?>(jsonRes['birthday']),
        userId: asT<int?>(jsonRes['userId']),
        userType: asT<int?>(jsonRes['userType']),
        nickname: asT<String?>(jsonRes['nickname']),
        signature: asT<String?>(jsonRes['signature']),
        description: asT<String?>(jsonRes['description']),
        detailDescription: asT<String?>(jsonRes['detailDescription']),
        avatarImgId: asT<int?>(jsonRes['avatarImgId']),
        backgroundImgId: asT<int?>(jsonRes['backgroundImgId']),
        backgroundUrl: asT<String?>(jsonRes['backgroundUrl']),
        authority: asT<int?>(jsonRes['authority']),
        mutual: asT<bool?>(jsonRes['mutual']),
        expertTags: asT<Object?>(jsonRes['expertTags']),
        experts: asT<Object?>(jsonRes['experts']),
        djStatus: asT<int?>(jsonRes['djStatus']),
        vipType: asT<int?>(jsonRes['vipType']),
        remarkName: asT<Object?>(jsonRes['remarkName']),
        authenticationTypes: asT<int?>(jsonRes['authenticationTypes']),
        avatarDetail: asT<Object?>(jsonRes['avatarDetail']),
        avatarImgIdStr: asT<String?>(jsonRes['avatarImgIdStr']),
        backgroundImgIdStr: asT<String?>(jsonRes['backgroundImgIdStr']),
        anchor: asT<bool?>(jsonRes['anchor']),
        avatarimgidStr: asT<String?>(jsonRes['avatarImgId_str']),
      );

  bool? defaultAvatar;
  int? province;
  int? authStatus;
  bool? followed;
  String? avatarUrl;
  int? accountStatus;
  int? gender;
  int? city;
  int? birthday;
  int? userId;
  int? userType;
  String? nickname;
  String? signature;
  String? description;
  String? detailDescription;
  int? avatarImgId;
  int? backgroundImgId;
  String? backgroundUrl;
  int? authority;
  bool? mutual;
  Object? expertTags;
  Object? experts;
  int? djStatus;
  int? vipType;
  Object? remarkName;
  int? authenticationTypes;
  Object? avatarDetail;
  String? avatarImgIdStr;
  String? backgroundImgIdStr;
  bool? anchor;
  String? avatarimgidStr;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'defaultAvatar': defaultAvatar,
        'province': province,
        'authStatus': authStatus,
        'followed': followed,
        'avatarUrl': avatarUrl,
        'accountStatus': accountStatus,
        'gender': gender,
        'city': city,
        'birthday': birthday,
        'userId': userId,
        'userType': userType,
        'nickname': nickname,
        'signature': signature,
        'description': description,
        'detailDescription': detailDescription,
        'avatarImgId': avatarImgId,
        'backgroundImgId': backgroundImgId,
        'backgroundUrl': backgroundUrl,
        'authority': authority,
        'mutual': mutual,
        'expertTags': expertTags,
        'experts': experts,
        'djStatus': djStatus,
        'vipType': vipType,
        'remarkName': remarkName,
        'authenticationTypes': authenticationTypes,
        'avatarDetail': avatarDetail,
        'avatarImgIdStr': avatarImgIdStr,
        'backgroundImgIdStr': backgroundImgIdStr,
        'anchor': anchor,
        'avatarImgId_str': avatarimgidStr,
      };

  Creator clone() => Creator.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Tracks {
  Tracks({
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
    this.tns,
  });

  factory Tracks.fromJson(Map<String, dynamic> jsonRes) {
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

    final List<String>? tns = jsonRes['tns'] is List ? <String>[] : null;
    if (tns != null) {
      for (final dynamic item in jsonRes['tns']!) {
        if (item != null) {
          tns.add(asT<String>(item)!);
        }
      }
    }
    return Tracks(
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
      tns: tns,
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
  List<String>? tns;

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
        'tns': tns,
      };

  Tracks clone() =>
      Tracks.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
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
      pic: asT<int?>(jsonRes['pic']),
    );
  }

  int? id;
  String? name;
  String? picUrl;
  List<Object>? tns;
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

class TrackIds {
  TrackIds({
    this.id,
    this.v,
    this.t,
    this.at,
    this.alg,
    this.uid,
    this.rcmdReason,
  });

  factory TrackIds.fromJson(Map<String, dynamic> jsonRes) => TrackIds(
        id: asT<int?>(jsonRes['id']),
        v: asT<int?>(jsonRes['v']),
        t: asT<int?>(jsonRes['t']),
        at: asT<int?>(jsonRes['at']),
        alg: asT<Object?>(jsonRes['alg']),
        uid: asT<int?>(jsonRes['uid']),
        rcmdReason: asT<String?>(jsonRes['rcmdReason']),
      );

  int? id;
  int? v;
  int? t;
  int? at;
  Object? alg;
  int? uid;
  String? rcmdReason;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'v': v,
        't': t,
        'at': at,
        'alg': alg,
        'uid': uid,
        'rcmdReason': rcmdReason,
      };

  TrackIds clone() => TrackIds.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Privileges {
  Privileges({
    this.id,
    this.fee,
    this.payed,
    this.realPayed,
    this.st,
    this.pl,
    this.dl,
    this.sp,
    this.cp,
    this.subp,
    this.cs,
    this.maxbr,
    this.fl,
    this.pc,
    this.toast,
    this.flag,
    this.paidBigBang,
    this.preSell,
    this.playMaxbr,
    this.downloadMaxbr,
    this.rscl,
    this.freeTrialPrivilege,
    this.chargeInfoList,
  });

  factory Privileges.fromJson(Map<String, dynamic> jsonRes) {
    final List<ChargeInfoList>? chargeInfoList =
        jsonRes['chargeInfoList'] is List ? <ChargeInfoList>[] : null;
    if (chargeInfoList != null) {
      for (final dynamic item in jsonRes['chargeInfoList']!) {
        if (item != null) {
          chargeInfoList
              .add(ChargeInfoList.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Privileges(
      id: asT<int?>(jsonRes['id']),
      fee: asT<int?>(jsonRes['fee']),
      payed: asT<int?>(jsonRes['payed']),
      realPayed: asT<int?>(jsonRes['realPayed']),
      st: asT<int?>(jsonRes['st']),
      pl: asT<int?>(jsonRes['pl']),
      dl: asT<int?>(jsonRes['dl']),
      sp: asT<int?>(jsonRes['sp']),
      cp: asT<int?>(jsonRes['cp']),
      subp: asT<int?>(jsonRes['subp']),
      cs: asT<bool?>(jsonRes['cs']),
      maxbr: asT<int?>(jsonRes['maxbr']),
      fl: asT<int?>(jsonRes['fl']),
      pc: asT<Object?>(jsonRes['pc']),
      toast: asT<bool?>(jsonRes['toast']),
      flag: asT<int?>(jsonRes['flag']),
      paidBigBang: asT<bool?>(jsonRes['paidBigBang']),
      preSell: asT<bool?>(jsonRes['preSell']),
      playMaxbr: asT<int?>(jsonRes['playMaxbr']),
      downloadMaxbr: asT<int?>(jsonRes['downloadMaxbr']),
      rscl: asT<int?>(jsonRes['rscl']),
      freeTrialPrivilege: jsonRes['freeTrialPrivilege'] == null
          ? null
          : FreeTrialPrivilege.fromJson(
              asT<Map<String, dynamic>>(jsonRes['freeTrialPrivilege'])!),
      chargeInfoList: chargeInfoList,
    );
  }

  int? id;
  int? fee;
  int? payed;
  int? realPayed;
  int? st;
  int? pl;
  int? dl;
  int? sp;
  int? cp;
  int? subp;
  bool? cs;
  int? maxbr;
  int? fl;
  Object? pc;
  bool? toast;
  int? flag;
  bool? paidBigBang;
  bool? preSell;
  int? playMaxbr;
  int? downloadMaxbr;
  int? rscl;
  FreeTrialPrivilege? freeTrialPrivilege;
  List<ChargeInfoList>? chargeInfoList;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'fee': fee,
        'payed': payed,
        'realPayed': realPayed,
        'st': st,
        'pl': pl,
        'dl': dl,
        'sp': sp,
        'cp': cp,
        'subp': subp,
        'cs': cs,
        'maxbr': maxbr,
        'fl': fl,
        'pc': pc,
        'toast': toast,
        'flag': flag,
        'paidBigBang': paidBigBang,
        'preSell': preSell,
        'playMaxbr': playMaxbr,
        'downloadMaxbr': downloadMaxbr,
        'rscl': rscl,
        'freeTrialPrivilege': freeTrialPrivilege,
        'chargeInfoList': chargeInfoList,
      };

  Privileges clone() => Privileges.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class FreeTrialPrivilege {
  FreeTrialPrivilege({
    this.resConsumable,
    this.userConsumable,
  });

  factory FreeTrialPrivilege.fromJson(Map<String, dynamic> jsonRes) =>
      FreeTrialPrivilege(
        resConsumable: asT<bool?>(jsonRes['resConsumable']),
        userConsumable: asT<bool?>(jsonRes['userConsumable']),
      );

  bool? resConsumable;
  bool? userConsumable;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'resConsumable': resConsumable,
        'userConsumable': userConsumable,
      };

  FreeTrialPrivilege clone() => FreeTrialPrivilege.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class ChargeInfoList {
  ChargeInfoList({
    this.rate,
    this.chargeUrl,
    this.chargeMessage,
    this.chargeType,
  });

  factory ChargeInfoList.fromJson(Map<String, dynamic> jsonRes) =>
      ChargeInfoList(
        rate: asT<int?>(jsonRes['rate']),
        chargeUrl: asT<Object?>(jsonRes['chargeUrl']),
        chargeMessage: asT<Object?>(jsonRes['chargeMessage']),
        chargeType: asT<int?>(jsonRes['chargeType']),
      );

  int? rate;
  Object? chargeUrl;
  Object? chargeMessage;
  int? chargeType;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'rate': rate,
        'chargeUrl': chargeUrl,
        'chargeMessage': chargeMessage,
        'chargeType': chargeType,
      };

  ChargeInfoList clone() => ChargeInfoList.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
