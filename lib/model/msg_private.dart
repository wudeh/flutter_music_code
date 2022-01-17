import 'dart:convert';
import 'dart:developer';

// 私信对话
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

class MsgPrivateModel {
  MsgPrivateModel({
    this.msgs,
    this.code,
    this.more,
    this.newMsgCount,
  });

  factory MsgPrivateModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<Msgs>? msgs = jsonRes['msgs'] is List ? <Msgs>[] : null;
    if (msgs != null) {
      for (final dynamic item in jsonRes['msgs']!) {
        if (item != null) {
          tryCatch(() {
            msgs.add(Msgs.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return MsgPrivateModel(
      msgs: msgs,
      code: asT<int?>(jsonRes['code']),
      more: asT<bool?>(jsonRes['more']),
      newMsgCount: asT<int?>(jsonRes['newMsgCount']),
    );
  }

  List<Msgs>? msgs;
  int? code;
  bool? more;
  int? newMsgCount;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'msgs': msgs,
        'code': code,
        'more': more,
        'newMsgCount': newMsgCount,
      };

  MsgPrivateModel clone() => MsgPrivateModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Msgs {
  Msgs({
    this.fromUser,
    this.toUser,
    this.noticeAccountFlag,
    this.noticeAccount,
    this.lastMsgTime,
    this.newMsgCount,
    this.lastMsg,
  });

  factory Msgs.fromJson(Map<String, dynamic> jsonRes) => Msgs(
        fromUser: jsonRes['fromUser'] == null
            ? null
            : FromUser.fromJson(
                asT<Map<String, dynamic>>(jsonRes['fromUser'])!),
        toUser: jsonRes['toUser'] == null
            ? null
            : ToUser.fromJson(asT<Map<String, dynamic>>(jsonRes['toUser'])!),
        noticeAccountFlag: asT<bool?>(jsonRes['noticeAccountFlag']),
        noticeAccount: asT<Object?>(jsonRes['noticeAccount']),
        lastMsgTime: asT<int?>(jsonRes['lastMsgTime']),
        newMsgCount: asT<int?>(jsonRes['newMsgCount']),
        lastMsg: asT<String?>(jsonRes['lastMsg']),
      );

  FromUser? fromUser;
  ToUser? toUser;
  bool? noticeAccountFlag;
  Object? noticeAccount;
  int? lastMsgTime;
  int? newMsgCount;
  String? lastMsg;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fromUser': fromUser,
        'toUser': toUser,
        'noticeAccountFlag': noticeAccountFlag,
        'noticeAccount': noticeAccount,
        'lastMsgTime': lastMsgTime,
        'newMsgCount': newMsgCount,
        'lastMsg': lastMsg,
      };

  Msgs clone() =>
      Msgs.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class FromUser {
  FromUser({
    this.description,
    this.gender,
    this.avatarImgId,
    this.followed,
    this.nickname,
    this.userType,
    this.avatarDetail,
    this.province,
    this.avatarUrl,
    this.authStatus,
    this.expertTags,
    this.remarkName,
    this.vipType,
    this.experts,
    this.birthday,
    this.accountStatus,
    this.city,
    this.detailDescription,
    this.defaultAvatar,
    this.djStatus,
    this.backgroundUrl,
    this.backgroundImgId,
    this.avatarImgIdStr,
    this.backgroundImgIdStr,
    this.mutual,
    this.userId,
    this.signature,
    this.authority,
    this.blacklist,
    this.artistName,
  });

  factory FromUser.fromJson(Map<String, dynamic> jsonRes) => FromUser(
        description: asT<String?>(jsonRes['description']),
        gender: asT<int?>(jsonRes['gender']),
        avatarImgId: asT<int?>(jsonRes['avatarImgId']),
        followed: asT<bool?>(jsonRes['followed']),
        nickname: asT<String?>(jsonRes['nickname']),
        userType: asT<int?>(jsonRes['userType']),
        avatarDetail: jsonRes['avatarDetail'] == null
            ? null
            : AvatarDetail.fromJson(
                asT<Map<String, dynamic>>(jsonRes['avatarDetail'])!),
        province: asT<int?>(jsonRes['province']),
        avatarUrl: asT<String?>(jsonRes['avatarUrl']),
        authStatus: asT<int?>(jsonRes['authStatus']),
        expertTags: asT<Object?>(jsonRes['expertTags']),
        remarkName: asT<Object?>(jsonRes['remarkName']),
        vipType: asT<int?>(jsonRes['vipType']),
        experts: asT<Object?>(jsonRes['experts']),
        birthday: asT<int?>(jsonRes['birthday']),
        accountStatus: asT<int?>(jsonRes['accountStatus']),
        city: asT<int?>(jsonRes['city']),
        detailDescription: asT<String?>(jsonRes['detailDescription']),
        defaultAvatar: asT<bool?>(jsonRes['defaultAvatar']),
        djStatus: asT<int?>(jsonRes['djStatus']),
        backgroundUrl: asT<String?>(jsonRes['backgroundUrl']),
        backgroundImgId: asT<int?>(jsonRes['backgroundImgId']),
        avatarImgIdStr: asT<String?>(jsonRes['avatarImgIdStr']),
        backgroundImgIdStr: asT<String?>(jsonRes['backgroundImgIdStr']),
        mutual: asT<bool?>(jsonRes['mutual']),
        userId: asT<int?>(jsonRes['userId']),
        signature: asT<String?>(jsonRes['signature']),
        authority: asT<int?>(jsonRes['authority']),
        blacklist: asT<bool?>(jsonRes['blacklist']),
        artistName: asT<String?>(jsonRes['artistName']),
      );

  String? description;
  int? gender;
  int? avatarImgId;
  bool? followed;
  String? nickname;
  int? userType;
  AvatarDetail? avatarDetail;
  int? province;
  String? avatarUrl;
  int? authStatus;
  Object? expertTags;
  Object? remarkName;
  int? vipType;
  Object? experts;
  int? birthday;
  int? accountStatus;
  int? city;
  String? detailDescription;
  bool? defaultAvatar;
  int? djStatus;
  String? backgroundUrl;
  int? backgroundImgId;
  String? avatarImgIdStr;
  String? backgroundImgIdStr;
  bool? mutual;
  int? userId;
  String? signature;
  int? authority;
  bool? blacklist;
  String? artistName;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'gender': gender,
        'avatarImgId': avatarImgId,
        'followed': followed,
        'nickname': nickname,
        'userType': userType,
        'avatarDetail': avatarDetail,
        'province': province,
        'avatarUrl': avatarUrl,
        'authStatus': authStatus,
        'expertTags': expertTags,
        'remarkName': remarkName,
        'vipType': vipType,
        'experts': experts,
        'birthday': birthday,
        'accountStatus': accountStatus,
        'city': city,
        'detailDescription': detailDescription,
        'defaultAvatar': defaultAvatar,
        'djStatus': djStatus,
        'backgroundUrl': backgroundUrl,
        'backgroundImgId': backgroundImgId,
        'avatarImgIdStr': avatarImgIdStr,
        'backgroundImgIdStr': backgroundImgIdStr,
        'mutual': mutual,
        'userId': userId,
        'signature': signature,
        'authority': authority,
        'blacklist': blacklist,
        'artistName': artistName,
      };

  FromUser clone() => FromUser.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class AvatarDetail {
  AvatarDetail({
    this.userType,
    this.identityLevel,
    this.identityIconUrl,
  });

  factory AvatarDetail.fromJson(Map<String, dynamic> jsonRes) => AvatarDetail(
        userType: asT<int?>(jsonRes['userType']),
        identityLevel: asT<int?>(jsonRes['identityLevel']),
        identityIconUrl: asT<String?>(jsonRes['identityIconUrl']),
      );

  int? userType;
  int? identityLevel;
  String? identityIconUrl;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userType': userType,
        'identityLevel': identityLevel,
        'identityIconUrl': identityIconUrl,
      };

  AvatarDetail clone() => AvatarDetail.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class ToUser {
  ToUser({
    this.description,
    this.gender,
    this.avatarImgId,
    this.followed,
    this.nickname,
    this.userType,
    this.avatarDetail,
    this.province,
    this.avatarUrl,
    this.authStatus,
    this.expertTags,
    this.remarkName,
    this.vipType,
    this.experts,
    this.birthday,
    this.accountStatus,
    this.city,
    this.detailDescription,
    this.defaultAvatar,
    this.djStatus,
    this.backgroundUrl,
    this.backgroundImgId,
    this.avatarImgIdStr,
    this.backgroundImgIdStr,
    this.mutual,
    this.userId,
    this.signature,
    this.authority,
  });

  factory ToUser.fromJson(Map<String, dynamic> jsonRes) => ToUser(
        description: asT<String?>(jsonRes['description']),
        gender: asT<int?>(jsonRes['gender']),
        avatarImgId: asT<int?>(jsonRes['avatarImgId']),
        followed: asT<bool?>(jsonRes['followed']),
        nickname: asT<String?>(jsonRes['nickname']),
        userType: asT<int?>(jsonRes['userType']),
        avatarDetail: asT<Object?>(jsonRes['avatarDetail']),
        province: asT<int?>(jsonRes['province']),
        avatarUrl: asT<String?>(jsonRes['avatarUrl']),
        authStatus: asT<int?>(jsonRes['authStatus']),
        expertTags: asT<Object?>(jsonRes['expertTags']),
        remarkName: asT<Object?>(jsonRes['remarkName']),
        vipType: asT<int?>(jsonRes['vipType']),
        experts: asT<Object?>(jsonRes['experts']),
        birthday: asT<int?>(jsonRes['birthday']),
        accountStatus: asT<int?>(jsonRes['accountStatus']),
        city: asT<int?>(jsonRes['city']),
        detailDescription: asT<String?>(jsonRes['detailDescription']),
        defaultAvatar: asT<bool?>(jsonRes['defaultAvatar']),
        djStatus: asT<int?>(jsonRes['djStatus']),
        backgroundUrl: asT<String?>(jsonRes['backgroundUrl']),
        backgroundImgId: asT<int?>(jsonRes['backgroundImgId']),
        avatarImgIdStr: asT<String?>(jsonRes['avatarImgIdStr']),
        backgroundImgIdStr: asT<String?>(jsonRes['backgroundImgIdStr']),
        mutual: asT<bool?>(jsonRes['mutual']),
        userId: asT<int?>(jsonRes['userId']),
        signature: asT<String?>(jsonRes['signature']),
        authority: asT<int?>(jsonRes['authority']),
      );

  String? description;
  int? gender;
  int? avatarImgId;
  bool? followed;
  String? nickname;
  int? userType;
  Object? avatarDetail;
  int? province;
  String? avatarUrl;
  int? authStatus;
  Object? expertTags;
  Object? remarkName;
  int? vipType;
  Object? experts;
  int? birthday;
  int? accountStatus;
  int? city;
  String? detailDescription;
  bool? defaultAvatar;
  int? djStatus;
  String? backgroundUrl;
  int? backgroundImgId;
  String? avatarImgIdStr;
  String? backgroundImgIdStr;
  bool? mutual;
  int? userId;
  String? signature;
  int? authority;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'gender': gender,
        'avatarImgId': avatarImgId,
        'followed': followed,
        'nickname': nickname,
        'userType': userType,
        'avatarDetail': avatarDetail,
        'province': province,
        'avatarUrl': avatarUrl,
        'authStatus': authStatus,
        'expertTags': expertTags,
        'remarkName': remarkName,
        'vipType': vipType,
        'experts': experts,
        'birthday': birthday,
        'accountStatus': accountStatus,
        'city': city,
        'detailDescription': detailDescription,
        'defaultAvatar': defaultAvatar,
        'djStatus': djStatus,
        'backgroundUrl': backgroundUrl,
        'backgroundImgId': backgroundImgId,
        'avatarImgIdStr': avatarImgIdStr,
        'backgroundImgIdStr': backgroundImgIdStr,
        'mutual': mutual,
        'userId': userId,
        'signature': signature,
        'authority': authority,
      };

  ToUser clone() =>
      ToUser.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
