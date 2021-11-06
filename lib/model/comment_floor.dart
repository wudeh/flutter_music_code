import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class commentFloorModel {
  commentFloorModel({
    this.code,
    this.message,
    this.data,
  });

  factory commentFloorModel.fromJson(Map<String, dynamic> jsonRes) => commentFloorModel(
        code: asT<int?>(jsonRes['code']),
        message: asT<String?>(jsonRes['message']),
        data: jsonRes['data'] == null
            ? null
            : Data.fromJson(asT<Map<String, dynamic>>(jsonRes['data'])!),
      );

  int? code;
  String? message;
  Data? data;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'message': message,
        'data': data,
      };

  commentFloorModel clone() => commentFloorModel
      .fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Data {
  Data({
    this.ownerComment,
    this.currentComment,
    this.comments,
    this.hasMore,
    this.totalCount,
    this.time,
  });

  factory Data.fromJson(Map<String, dynamic> jsonRes) {
    final List<Comments2>? comments =
        jsonRes['comments'] is List ? <Comments2>[] : null;
    if (comments != null) {
      for (final dynamic item in jsonRes['comments']!) {
        if (item != null) {
          comments.add(Comments2.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Data(
      ownerComment: asT<Object?>(jsonRes['ownerComment']),
      currentComment: asT<Object?>(jsonRes['currentComment']),
      comments: comments,
      hasMore: asT<bool?>(jsonRes['hasMore']),
      totalCount: asT<int?>(jsonRes['totalCount']),
      time: asT<int?>(jsonRes['time']),
    );
  }

  Object? ownerComment;
  Object? currentComment;
  List<Comments2>? comments;
  bool? hasMore;
  int? totalCount;
  int? time;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ownerComment': ownerComment,
        'currentComment': currentComment,
        'comments': comments,
        'hasMore': hasMore,
        'totalCount': totalCount,
        'time': time,
      };

  Data clone() =>
      Data.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Comments2 {
  Comments2({
    this.user,
    this.beReplied,
    this.pendantData,
    this.showFloorComment,
    this.status,
    this.commentId,
    this.content,
    this.time,
    this.likedCount,
    this.expressionUrl,
    this.commentLocationType,
    this.parentCommentId,
    this.decoration,
    this.repliedMark,
    this.liked,
  });

  factory Comments2.fromJson(Map<String, dynamic> jsonRes) {
    final List<BeReplied>? beReplied =
        jsonRes['beReplied'] is List ? <BeReplied>[] : null;
    if (beReplied != null) {
      for (final dynamic item in jsonRes['beReplied']!) {
        if (item != null) {
          beReplied.add(BeReplied.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Comments2(
      user: jsonRes['user'] == null
          ? null
          : User.fromJson(asT<Map<String, dynamic>>(jsonRes['user'])!),
      beReplied: beReplied,
      pendantData: asT<Object?>(jsonRes['pendantData']),
      showFloorComment: asT<Object?>(jsonRes['showFloorComment']),
      status: asT<int?>(jsonRes['status']),
      commentId: asT<int?>(jsonRes['commentId']),
      content: asT<String?>(jsonRes['content']),
      time: asT<int?>(jsonRes['time']),
      likedCount: asT<int?>(jsonRes['likedCount']),
      expressionUrl: asT<Object?>(jsonRes['expressionUrl']),
      commentLocationType: asT<int?>(jsonRes['commentLocationType']),
      parentCommentId: asT<int?>(jsonRes['parentCommentId']),
      decoration: asT<Object?>(jsonRes['decoration']),
      repliedMark: asT<Object?>(jsonRes['repliedMark']),
      liked: asT<bool?>(jsonRes['liked']),
    );
  }

  User? user;
  List<BeReplied>? beReplied;
  Object? pendantData;
  Object? showFloorComment;
  int? status;
  int? commentId;
  String? content;
  int? time;
  int? likedCount;
  Object? expressionUrl;
  int? commentLocationType;
  int? parentCommentId;
  Object? decoration;
  Object? repliedMark;
  bool? liked;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user,
        'beReplied': beReplied,
        'pendantData': pendantData,
        'showFloorComment': showFloorComment,
        'status': status,
        'commentId': commentId,
        'content': content,
        'time': time,
        'likedCount': likedCount,
        'expressionUrl': expressionUrl,
        'commentLocationType': commentLocationType,
        'parentCommentId': parentCommentId,
        'decoration': decoration,
        'repliedMark': repliedMark,
        'liked': liked,
      };

  Comments2 clone() => Comments2.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class User {
  User({
    this.locationInfo,
    this.liveInfo,
    this.anonym,
    this.commonIdentity,
    this.userId,
    this.avatarDetail,
    this.userType,
    this.followed,
    this.mutual,
    this.remarkName,
    this.vipRights,
    this.nickname,
    this.avatarUrl,
    this.authStatus,
    this.expertTags,
    this.experts,
    this.vipType,
  });

  factory User.fromJson(Map<String, dynamic> jsonRes) => User(
        locationInfo: asT<Object?>(jsonRes['locationInfo']),
        liveInfo: asT<Object?>(jsonRes['liveInfo']),
        anonym: asT<int?>(jsonRes['anonym']),
        commonIdentity: asT<Object?>(jsonRes['commonIdentity']),
        userId: asT<int?>(jsonRes['userId']),
        avatarDetail: asT<Object?>(jsonRes['avatarDetail']),
        userType: asT<int?>(jsonRes['userType']),
        followed: asT<bool?>(jsonRes['followed']),
        mutual: asT<bool?>(jsonRes['mutual']),
        remarkName: asT<Object?>(jsonRes['remarkName']),
        vipRights: asT<Object?>(jsonRes['vipRights']),
        nickname: asT<String?>(jsonRes['nickname']),
        avatarUrl: asT<String?>(jsonRes['avatarUrl']),
        authStatus: asT<int?>(jsonRes['authStatus']),
        expertTags: asT<Object?>(jsonRes['expertTags']),
        experts: asT<Object?>(jsonRes['experts']),
        vipType: asT<int?>(jsonRes['vipType']),
      );

  Object? locationInfo;
  Object? liveInfo;
  int? anonym;
  Object? commonIdentity;
  int? userId;
  Object? avatarDetail;
  int? userType;
  bool? followed;
  bool? mutual;
  Object? remarkName;
  Object? vipRights;
  String? nickname;
  String? avatarUrl;
  int? authStatus;
  Object? expertTags;
  Object? experts;
  int? vipType;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'locationInfo': locationInfo,
        'liveInfo': liveInfo,
        'anonym': anonym,
        'commonIdentity': commonIdentity,
        'userId': userId,
        'avatarDetail': avatarDetail,
        'userType': userType,
        'followed': followed,
        'mutual': mutual,
        'remarkName': remarkName,
        'vipRights': vipRights,
        'nickname': nickname,
        'avatarUrl': avatarUrl,
        'authStatus': authStatus,
        'expertTags': expertTags,
        'experts': experts,
        'vipType': vipType,
      };

  User clone() =>
      User.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class BeReplied {
  BeReplied({
    this.user,
    this.beRepliedCommentId,
    this.content,
    this.status,
    this.expressionUrl,
  });

  factory BeReplied.fromJson(Map<String, dynamic> jsonRes) => BeReplied(
        user: jsonRes['user'] == null
            ? null
            : User.fromJson(asT<Map<String, dynamic>>(jsonRes['user'])!),
        beRepliedCommentId: asT<int?>(jsonRes['beRepliedCommentId']),
        content: asT<String?>(jsonRes['content']),
        status: asT<int?>(jsonRes['status']),
        expressionUrl: asT<Object?>(jsonRes['expressionUrl']),
      );

  User? user;
  int? beRepliedCommentId;
  String? content;
  int? status;
  Object? expressionUrl;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user,
        'beRepliedCommentId': beRepliedCommentId,
        'content': content,
        'status': status,
        'expressionUrl': expressionUrl,
      };

  BeReplied clone() => BeReplied.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class User2 {
  User2({
    this.locationInfo,
    this.liveInfo,
    this.anonym,
    this.commonIdentity,
    this.userId,
    this.avatarDetail,
    this.userType,
    this.followed,
    this.mutual,
    this.remarkName,
    this.vipRights,
    this.nickname,
    this.avatarUrl,
    this.authStatus,
    this.expertTags,
    this.experts,
    this.vipType,
  });

  factory User2.fromJson(Map<String, dynamic> jsonRes) => User2(
        locationInfo: asT<Object?>(jsonRes['locationInfo']),
        liveInfo: asT<Object?>(jsonRes['liveInfo']),
        anonym: asT<int?>(jsonRes['anonym']),
        commonIdentity: asT<Object?>(jsonRes['commonIdentity']),
        userId: asT<int?>(jsonRes['userId']),
        avatarDetail: jsonRes['avatarDetail'] == null
            ? null
            : AvatarDetail.fromJson(
                asT<Map<String, dynamic>>(jsonRes['avatarDetail'])!),
        userType: asT<int?>(jsonRes['userType']),
        followed: asT<bool?>(jsonRes['followed']),
        mutual: asT<bool?>(jsonRes['mutual']),
        remarkName: asT<Object?>(jsonRes['remarkName']),
        vipRights: asT<Object?>(jsonRes['vipRights']),
        nickname: asT<String?>(jsonRes['nickname']),
        avatarUrl: asT<String?>(jsonRes['avatarUrl']),
        authStatus: asT<int?>(jsonRes['authStatus']),
        expertTags: asT<Object?>(jsonRes['expertTags']),
        experts: asT<Object?>(jsonRes['experts']),
        vipType: asT<int?>(jsonRes['vipType']),
      );

  Object? locationInfo;
  Object? liveInfo;
  int? anonym;
  Object? commonIdentity;
  int? userId;
  AvatarDetail? avatarDetail;
  int? userType;
  bool? followed;
  bool? mutual;
  Object? remarkName;
  Object? vipRights;
  String? nickname;
  String? avatarUrl;
  int? authStatus;
  Object? expertTags;
  Object? experts;
  int? vipType;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'locationInfo': locationInfo,
        'liveInfo': liveInfo,
        'anonym': anonym,
        'commonIdentity': commonIdentity,
        'userId': userId,
        'avatarDetail': avatarDetail,
        'userType': userType,
        'followed': followed,
        'mutual': mutual,
        'remarkName': remarkName,
        'vipRights': vipRights,
        'nickname': nickname,
        'avatarUrl': avatarUrl,
        'authStatus': authStatus,
        'expertTags': expertTags,
        'experts': experts,
        'vipType': vipType,
      };

  User clone() =>
      User.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
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
