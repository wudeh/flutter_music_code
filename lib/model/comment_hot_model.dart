import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class CommentHotModel {
  CommentHotModel({
    this.topComments,
    this.hasMore,
    this.hotComments,
    this.total,
    this.code,
  });

  factory CommentHotModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? topComments =
        jsonRes['topComments'] is List ? <Object>[] : null;
    if (topComments != null) {
      for (final dynamic item in jsonRes['topComments']!) {
        if (item != null) {
          topComments.add(asT<Object>(item)!);
        }
      }
    }

    final List<HotComments>? hotComments =
        jsonRes['hotComments'] is List ? <HotComments>[] : null;
    if (hotComments != null) {
      for (final dynamic item in jsonRes['hotComments']!) {
        if (item != null) {
          hotComments
              .add(HotComments.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return CommentHotModel(
      topComments: topComments,
      hasMore: asT<bool?>(jsonRes['hasMore']),
      hotComments: hotComments,
      total: asT<int?>(jsonRes['total']),
      code: asT<int?>(jsonRes['code']),
    );
  }

  List<Object>? topComments;
  bool? hasMore;
  List<HotComments>? hotComments;
  int? total;
  int? code;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'topComments': topComments,
        'hasMore': hasMore,
        'hotComments': hotComments,
        'total': total,
        'code': code,
      };

  CommentHotModel clone() => CommentHotModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class HotComments {
  HotComments({
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

  factory HotComments.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? beReplied =
        jsonRes['beReplied'] is List ? <Object>[] : null;
    if (beReplied != null) {
      for (final dynamic item in jsonRes['beReplied']!) {
        if (item != null) {
          beReplied.add(asT<Object>(item)!);
        }
      }
    }
    return HotComments(
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
  List<Object>? beReplied;
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

  HotComments clone() => HotComments.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class User {
  User({
    this.locationInfo,
    this.liveInfo,
    this.anonym,
    this.commonIdentity,
    this.userId,
    this.userType,
    this.avatarDetail,
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
        userType: asT<int?>(jsonRes['userType']),
        avatarDetail: asT<Object?>(jsonRes['avatarDetail']),
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
  int? userType;
  Object? avatarDetail;
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
        'userType': userType,
        'avatarDetail': avatarDetail,
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
