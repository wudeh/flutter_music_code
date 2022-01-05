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

class LoginModel {
  LoginModel({
    this.loginType,
    this.code,
    this.account,
    this.token,
    this.profile,
    this.bindings,
    this.cookie,
  });

  factory LoginModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<Bindings>? bindings =
        jsonRes['bindings'] is List ? <Bindings>[] : null;
    if (bindings != null) {
      for (final dynamic item in jsonRes['bindings']!) {
        if (item != null) {
          tryCatch(() {
            bindings.add(Bindings.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return LoginModel(
      loginType: asT<int?>(jsonRes['loginType']),
      code: asT<int?>(jsonRes['code']),
      account: jsonRes['account'] == null
          ? null
          : Account.fromJson(asT<Map<String, dynamic>>(jsonRes['account'])!),
      token: asT<String?>(jsonRes['token']),
      profile: jsonRes['profile'] == null
          ? null
          : Profile.fromJson(asT<Map<String, dynamic>>(jsonRes['profile'])!),
      bindings: bindings,
      cookie: asT<String?>(jsonRes['cookie']),
    );
  }

  int? loginType;
  int? code;
  Account? account;
  String? token;
  Profile? profile;
  List<Bindings>? bindings;
  String? cookie;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'loginType': loginType,
        'code': code,
        'account': account,
        'token': token,
        'profile': profile,
        'bindings': bindings,
        'cookie': cookie,
      };

  LoginModel clone() => LoginModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Account {
  Account({
    this.id,
    this.userName,
    this.type,
    this.status,
    this.whitelistAuthority,
    this.createTime,
    this.salt,
    this.tokenVersion,
    this.ban,
    this.baoyueVersion,
    this.donateVersion,
    this.vipType,
    this.viptypeVersion,
    this.anonimousUser,
    this.uninitialized,
  });

  factory Account.fromJson(Map<String, dynamic> jsonRes) => Account(
        id: asT<int?>(jsonRes['id']),
        userName: asT<String?>(jsonRes['userName']),
        type: asT<int?>(jsonRes['type']),
        status: asT<int?>(jsonRes['status']),
        whitelistAuthority: asT<int?>(jsonRes['whitelistAuthority']),
        createTime: asT<int?>(jsonRes['createTime']),
        salt: asT<String?>(jsonRes['salt']),
        tokenVersion: asT<int?>(jsonRes['tokenVersion']),
        ban: asT<int?>(jsonRes['ban']),
        baoyueVersion: asT<int?>(jsonRes['baoyueVersion']),
        donateVersion: asT<int?>(jsonRes['donateVersion']),
        vipType: asT<int?>(jsonRes['vipType']),
        viptypeVersion: asT<int?>(jsonRes['viptypeVersion']),
        anonimousUser: asT<bool?>(jsonRes['anonimousUser']),
        uninitialized: asT<bool?>(jsonRes['uninitialized']),
      );

  int? id;
  String? userName;
  int? type;
  int? status;
  int? whitelistAuthority;
  int? createTime;
  String? salt;
  int? tokenVersion;
  int? ban;
  int? baoyueVersion;
  int? donateVersion;
  int? vipType;
  int? viptypeVersion;
  bool? anonimousUser;
  bool? uninitialized;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userName': userName,
        'type': type,
        'status': status,
        'whitelistAuthority': whitelistAuthority,
        'createTime': createTime,
        'salt': salt,
        'tokenVersion': tokenVersion,
        'ban': ban,
        'baoyueVersion': baoyueVersion,
        'donateVersion': donateVersion,
        'vipType': vipType,
        'viptypeVersion': viptypeVersion,
        'anonimousUser': anonimousUser,
        'uninitialized': uninitialized,
      };

  Account clone() => Account.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Profile {
  Profile({
    this.followed,
    this.backgroundUrl,
    this.detailDescription,
    this.avatarImgIdStr,
    this.backgroundImgIdStr,
    this.userId,
    this.userType,
    this.accountStatus,
    this.gender,
    this.vipType,
    this.avatarImgId,
    this.nickname,
    this.backgroundImgId,
    this.birthday,
    this.city,
    this.avatarUrl,
    this.defaultAvatar,
    this.province,
    this.expertTags,
    this.experts,
    this.mutual,
    this.remarkName,
    this.authStatus,
    this.djStatus,
    this.description,
    this.signature,
    this.authority,
    this.avatarimgidStr,
    this.followeds,
    this.follows,
    this.eventCount,
    this.avatarDetail,
    this.playlistCount,
    this.playlistBeSubscribedCount,
  });

  factory Profile.fromJson(Map<String, dynamic> jsonRes) => Profile(
        followed: asT<bool?>(jsonRes['followed']),
        backgroundUrl: asT<String?>(jsonRes['backgroundUrl']),
        detailDescription: asT<String?>(jsonRes['detailDescription']),
        avatarImgIdStr: asT<String?>(jsonRes['avatarImgIdStr']),
        backgroundImgIdStr: asT<String?>(jsonRes['backgroundImgIdStr']),
        userId: asT<int?>(jsonRes['userId']),
        userType: asT<int?>(jsonRes['userType']),
        accountStatus: asT<int?>(jsonRes['accountStatus']),
        gender: asT<int?>(jsonRes['gender']),
        vipType: asT<int?>(jsonRes['vipType']),
        avatarImgId: asT<int?>(jsonRes['avatarImgId']),
        nickname: asT<String?>(jsonRes['nickname']),
        backgroundImgId: asT<int?>(jsonRes['backgroundImgId']),
        birthday: asT<int?>(jsonRes['birthday']),
        city: asT<int?>(jsonRes['city']),
        avatarUrl: asT<String?>(jsonRes['avatarUrl']),
        defaultAvatar: asT<bool?>(jsonRes['defaultAvatar']),
        province: asT<int?>(jsonRes['province']),
        expertTags: asT<Object?>(jsonRes['expertTags']),
        experts: asT<Object?>(jsonRes['experts']),
        mutual: asT<bool?>(jsonRes['mutual']),
        remarkName: asT<Object?>(jsonRes['remarkName']),
        authStatus: asT<int?>(jsonRes['authStatus']),
        djStatus: asT<int?>(jsonRes['djStatus']),
        description: asT<String?>(jsonRes['description']),
        signature: asT<String?>(jsonRes['signature']),
        authority: asT<int?>(jsonRes['authority']),
        avatarimgidStr: asT<String?>(jsonRes['avatarImgId_str']),
        followeds: asT<int?>(jsonRes['followeds']),
        follows: asT<int?>(jsonRes['follows']),
        eventCount: asT<int?>(jsonRes['eventCount']),
        avatarDetail: asT<Object?>(jsonRes['avatarDetail']),
        playlistCount: asT<int?>(jsonRes['playlistCount']),
        playlistBeSubscribedCount:
            asT<int?>(jsonRes['playlistBeSubscribedCount']),
      );

  bool? followed;
  String? backgroundUrl;
  String? detailDescription;
  String? avatarImgIdStr;
  String? backgroundImgIdStr;
  int? userId;
  int? userType;
  int? accountStatus;
  int? gender;
  int? vipType;
  int? avatarImgId;
  String? nickname;
  int? backgroundImgId;
  int? birthday;
  int? city;
  String? avatarUrl;
  bool? defaultAvatar;
  int? province;
  Object? expertTags;
  Object? experts;
  bool? mutual;
  Object? remarkName;
  int? authStatus;
  int? djStatus;
  String? description;
  String? signature;
  int? authority;
  String? avatarimgidStr;
  int? followeds;
  int? follows;
  int? eventCount;
  Object? avatarDetail;
  int? playlistCount;
  int? playlistBeSubscribedCount;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'followed': followed,
        'backgroundUrl': backgroundUrl,
        'detailDescription': detailDescription,
        'avatarImgIdStr': avatarImgIdStr,
        'backgroundImgIdStr': backgroundImgIdStr,
        'userId': userId,
        'userType': userType,
        'accountStatus': accountStatus,
        'gender': gender,
        'vipType': vipType,
        'avatarImgId': avatarImgId,
        'nickname': nickname,
        'backgroundImgId': backgroundImgId,
        'birthday': birthday,
        'city': city,
        'avatarUrl': avatarUrl,
        'defaultAvatar': defaultAvatar,
        'province': province,
        'expertTags': expertTags,
        'experts': experts,
        'mutual': mutual,
        'remarkName': remarkName,
        'authStatus': authStatus,
        'djStatus': djStatus,
        'description': description,
        'signature': signature,
        'authority': authority,
        'avatarImgId_str': avatarimgidStr,
        'followeds': followeds,
        'follows': follows,
        'eventCount': eventCount,
        'avatarDetail': avatarDetail,
        'playlistCount': playlistCount,
        'playlistBeSubscribedCount': playlistBeSubscribedCount,
      };

  Profile clone() => Profile.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Bindings {
  Bindings({
    this.userId,
    this.url,
    this.expired,
    this.bindingTime,
    this.tokenJsonStr,
    this.expiresIn,
    this.refreshTime,
    this.id,
    this.type,
  });

  factory Bindings.fromJson(Map<String, dynamic> jsonRes) => Bindings(
        userId: asT<int?>(jsonRes['userId']),
        url: asT<String?>(jsonRes['url']),
        expired: asT<bool?>(jsonRes['expired']),
        bindingTime: asT<int?>(jsonRes['bindingTime']),
        tokenJsonStr: asT<String?>(jsonRes['tokenJsonStr']),
        expiresIn: asT<int?>(jsonRes['expiresIn']),
        refreshTime: asT<int?>(jsonRes['refreshTime']),
        id: asT<int?>(jsonRes['id']),
        type: asT<int?>(jsonRes['type']),
      );

  int? userId;
  String? url;
  bool? expired;
  int? bindingTime;
  String? tokenJsonStr;
  int? expiresIn;
  int? refreshTime;
  int? id;
  int? type;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'url': url,
        'expired': expired,
        'bindingTime': bindingTime,
        'tokenJsonStr': tokenJsonStr,
        'expiresIn': expiresIn,
        'refreshTime': refreshTime,
        'id': id,
        'type': type,
      };

  Bindings clone() => Bindings.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
