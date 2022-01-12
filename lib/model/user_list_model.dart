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

class UserPlayList {
  UserPlayList({
    this.version,
    this.more,
    this.playlist,
    this.code,
  });

  factory UserPlayList.fromJson(Map<String, dynamic> jsonRes) {
    final List<Playlist>? playlist =
        jsonRes['playlist'] is List ? <Playlist>[] : null;
    if (playlist != null) {
      for (final dynamic item in jsonRes['playlist']!) {
        if (item != null) {
          tryCatch(() {
            playlist.add(Playlist.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return UserPlayList(
      version: asT<String?>(jsonRes['version']),
      more: asT<bool?>(jsonRes['more']),
      playlist: playlist,
      code: asT<int?>(jsonRes['code']),
    );
  }

  String? version;
  bool? more;
  List<Playlist>? playlist;
  int? code;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'version': version,
        'more': more,
        'playlist': playlist,
        'code': code,
      };

  UserPlayList clone() => UserPlayList.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Playlist {
  Playlist({
    this.subscribers,
    this.subscribed,
    this.creator,
    this.artists,
    this.tracks,
    this.updateFrequency,
    this.backgroundCoverId,
    this.backgroundCoverUrl,
    this.titleImage,
    this.titleImageUrl,
    this.englishTitle,
    this.opRecommend,
    this.recommendInfo,
    this.subscribedCount,
    this.cloudTrackCount,
    this.userId,
    this.totalDuration,
    this.coverImgId,
    this.privacy,
    this.trackUpdateTime,
    this.trackCount,
    this.updateTime,
    this.commentThreadId,
    this.coverImgUrl,
    this.specialType,
    this.anonimous,
    this.createTime,
    this.highQuality,
    this.newImported,
    this.trackNumberUpdateTime,
    this.playCount,
    this.adType,
    this.description,
    this.tags,
    this.ordered,
    this.status,
    this.name,
    this.id,
    this.coverimgidStr,
    this.sharedUsers,
    this.shareStatus,
  });

  factory Playlist.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? subscribers =
        jsonRes['subscribers'] is List ? <Object>[] : null;
    if (subscribers != null) {
      for (final dynamic item in jsonRes['subscribers']!) {
        if (item != null) {
          tryCatch(() {
            subscribers.add(asT<Object>(item)!);
          });
        }
      }
    }

    final List<String>? tags = jsonRes['tags'] is List ? <String>[] : null;
    if (tags != null) {
      for (final dynamic item in jsonRes['tags']!) {
        if (item != null) {
          tryCatch(() {
            tags.add(asT<String>(item)!);
          });
        }
      }
    }
    return Playlist(
      subscribers: subscribers,
      subscribed: asT<bool?>(jsonRes['subscribed']),
      creator: jsonRes['creator'] == null
          ? null
          : Creator.fromJson(asT<Map<String, dynamic>>(jsonRes['creator'])!),
      artists: asT<Object?>(jsonRes['artists']),
      tracks: asT<Object?>(jsonRes['tracks']),
      updateFrequency: asT<Object?>(jsonRes['updateFrequency']),
      backgroundCoverId: asT<int?>(jsonRes['backgroundCoverId']),
      backgroundCoverUrl: asT<Object?>(jsonRes['backgroundCoverUrl']),
      titleImage: asT<int?>(jsonRes['titleImage']),
      titleImageUrl: asT<Object?>(jsonRes['titleImageUrl']),
      englishTitle: asT<Object?>(jsonRes['englishTitle']),
      opRecommend: asT<bool?>(jsonRes['opRecommend']),
      recommendInfo: asT<Object?>(jsonRes['recommendInfo']),
      subscribedCount: asT<int?>(jsonRes['subscribedCount']),
      cloudTrackCount: asT<int?>(jsonRes['cloudTrackCount']),
      userId: asT<int?>(jsonRes['userId']),
      totalDuration: asT<int?>(jsonRes['totalDuration']),
      coverImgId: asT<int?>(jsonRes['coverImgId']),
      privacy: asT<int?>(jsonRes['privacy']),
      trackUpdateTime: asT<int?>(jsonRes['trackUpdateTime']),
      trackCount: asT<int?>(jsonRes['trackCount']),
      updateTime: asT<int?>(jsonRes['updateTime']),
      commentThreadId: asT<String?>(jsonRes['commentThreadId']),
      coverImgUrl: asT<String?>(jsonRes['coverImgUrl']),
      specialType: asT<int?>(jsonRes['specialType']),
      anonimous: asT<bool?>(jsonRes['anonimous']),
      createTime: asT<int?>(jsonRes['createTime']),
      highQuality: asT<bool?>(jsonRes['highQuality']),
      newImported: asT<bool?>(jsonRes['newImported']),
      trackNumberUpdateTime: asT<int?>(jsonRes['trackNumberUpdateTime']),
      playCount: asT<int?>(jsonRes['playCount']),
      adType: asT<int?>(jsonRes['adType']),
      description: asT<String?>(jsonRes['description']),
      tags: tags,
      ordered: asT<bool?>(jsonRes['ordered']),
      status: asT<int?>(jsonRes['status']),
      name: asT<String?>(jsonRes['name']),
      id: asT<int?>(jsonRes['id']),
      coverimgidStr: asT<String?>(jsonRes['coverImgId_str']),
      sharedUsers: asT<Object?>(jsonRes['sharedUsers']),
      shareStatus: asT<Object?>(jsonRes['shareStatus']),
    );
  }

  List<Object>? subscribers;
  bool? subscribed;
  Creator? creator;
  Object? artists;
  Object? tracks;
  Object? updateFrequency;
  int? backgroundCoverId;
  Object? backgroundCoverUrl;
  int? titleImage;
  Object? titleImageUrl;
  Object? englishTitle;
  bool? opRecommend;
  Object? recommendInfo;
  int? subscribedCount;
  int? cloudTrackCount;
  int? userId;
  int? totalDuration;
  int? coverImgId;
  int? privacy;
  int? trackUpdateTime;
  int? trackCount;
  int? updateTime;
  String? commentThreadId;
  String? coverImgUrl;
  int? specialType;
  bool? anonimous;
  int? createTime;
  bool? highQuality;
  bool? newImported;
  int? trackNumberUpdateTime;
  int? playCount;
  int? adType;
  String? description;
  List<String>? tags;
  bool? ordered;
  int? status;
  String? name;
  int? id;
  String? coverimgidStr;
  Object? sharedUsers;
  Object? shareStatus;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'subscribers': subscribers,
        'subscribed': subscribed,
        'creator': creator,
        'artists': artists,
        'tracks': tracks,
        'updateFrequency': updateFrequency,
        'backgroundCoverId': backgroundCoverId,
        'backgroundCoverUrl': backgroundCoverUrl,
        'titleImage': titleImage,
        'titleImageUrl': titleImageUrl,
        'englishTitle': englishTitle,
        'opRecommend': opRecommend,
        'recommendInfo': recommendInfo,
        'subscribedCount': subscribedCount,
        'cloudTrackCount': cloudTrackCount,
        'userId': userId,
        'totalDuration': totalDuration,
        'coverImgId': coverImgId,
        'privacy': privacy,
        'trackUpdateTime': trackUpdateTime,
        'trackCount': trackCount,
        'updateTime': updateTime,
        'commentThreadId': commentThreadId,
        'coverImgUrl': coverImgUrl,
        'specialType': specialType,
        'anonimous': anonimous,
        'createTime': createTime,
        'highQuality': highQuality,
        'newImported': newImported,
        'trackNumberUpdateTime': trackNumberUpdateTime,
        'playCount': playCount,
        'adType': adType,
        'description': description,
        'tags': tags,
        'ordered': ordered,
        'status': status,
        'name': name,
        'id': id,
        'coverImgId_str': coverimgidStr,
        'sharedUsers': sharedUsers,
        'shareStatus': shareStatus,
      };

  Playlist clone() => Playlist.fromJson(
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
    this.anchor,
    this.avatarImgIdStr,
    this.backgroundImgIdStr,
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
        anchor: asT<bool?>(jsonRes['anchor']),
        avatarImgIdStr: asT<String?>(jsonRes['avatarImgIdStr']),
        backgroundImgIdStr: asT<String?>(jsonRes['backgroundImgIdStr']),
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
  bool? anchor;
  String? avatarImgIdStr;
  String? backgroundImgIdStr;
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
        'anchor': anchor,
        'avatarImgIdStr': avatarImgIdStr,
        'backgroundImgIdStr': backgroundImgIdStr,
        'avatarImgId_str': avatarimgidStr,
      };

  Creator clone() => Creator.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
