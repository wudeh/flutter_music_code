import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class commentModel {
  commentModel({
    this.code,
    this.data,
  });

  factory commentModel.fromJson(Map<String, dynamic> jsonRes) => commentModel(
        code: asT<int?>(jsonRes['code']),
        data: jsonRes['data'] == null
            ? null
            : Data.fromJson(asT<Map<String, dynamic>>(jsonRes['data'])!),
      );

  int? code;
  Data? data;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'data': data,
      };

  commentModel clone() => commentModel
      .fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Data {
  Data({
    this.comments,
    this.currentComment,
    this.totalCount,
    this.hasMore,
    this.cursor,
    this.sortType,
    this.sortTypeList,
  });

  factory Data.fromJson(Map<String, dynamic> jsonRes) {
    final List<Comments>? comments =
        jsonRes['comments'] is List ? <Comments>[] : null;
    if (comments != null) {
      for (final dynamic item in jsonRes['comments']!) {
        if (item != null) {
          comments.add(Comments.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<SortTypeList>? sortTypeList =
        jsonRes['sortTypeList'] is List ? <SortTypeList>[] : null;
    if (sortTypeList != null) {
      for (final dynamic item in jsonRes['sortTypeList']!) {
        if (item != null) {
          sortTypeList
              .add(SortTypeList.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Data(
      comments: comments,
      currentComment: asT<Object?>(jsonRes['currentComment']),
      totalCount: asT<int?>(jsonRes['totalCount']),
      hasMore: asT<bool?>(jsonRes['hasMore']),
      cursor: asT<String?>(jsonRes['cursor']),
      sortType: asT<int?>(jsonRes['sortType']),
      sortTypeList: sortTypeList,
    );
  }

  List<Comments>? comments;
  Object? currentComment;
  int? totalCount;
  bool? hasMore;
  String? cursor;
  int? sortType;
  List<SortTypeList>? sortTypeList;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'comments': comments,
        'currentComment': currentComment,
        'totalCount': totalCount,
        'hasMore': hasMore,
        'cursor': cursor,
        'sortType': sortType,
        'sortTypeList': sortTypeList,
      };

  Data clone() =>
      Data.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Comments {
  Comments({
    this.user,
    this.beReplied,
    this.commentId,
    this.content,
    this.status,
    this.time,
    this.likedCount,
    this.liked,
    this.expressionUrl,
    this.parentCommentId,
    this.repliedMark,
    this.pendantData,
    this.showFloorComment,
    this.decoration,
    this.commentLocationType,
    this.args,
    this.tag,
    this.source,
    this.extInfo,
    this.commentVideoVO,
  });

  factory Comments.fromJson(Map<String, dynamic> jsonRes) => Comments(
        user: jsonRes['user'] == null
            ? null
            : User.fromJson(asT<Map<String, dynamic>>(jsonRes['user'])!),
        beReplied: asT<Object?>(jsonRes['beReplied']),
        commentId: asT<int?>(jsonRes['commentId']),
        content: asT<String?>(jsonRes['content']),
        status: asT<int?>(jsonRes['status']),
        time: asT<int?>(jsonRes['time']),
        likedCount: asT<int?>(jsonRes['likedCount']),
        liked: asT<bool?>(jsonRes['liked']),
        expressionUrl: asT<Object?>(jsonRes['expressionUrl']),
        parentCommentId: asT<int?>(jsonRes['parentCommentId']),
        repliedMark: asT<bool?>(jsonRes['repliedMark']),
        pendantData: asT<Object?>(jsonRes['pendantData']),
        showFloorComment: jsonRes['showFloorComment'] == null
            ? null
            : ShowFloorComment.fromJson(
                asT<Map<String, dynamic>>(jsonRes['showFloorComment'])!),
        decoration: jsonRes['decoration'] == null
            ? null
            : Decoration.fromJson(
                asT<Map<String, dynamic>>(jsonRes['decoration'])!),
        commentLocationType: asT<int?>(jsonRes['commentLocationType']),
        args: asT<Object?>(jsonRes['args']),
        tag: jsonRes['tag'] == null
            ? null
            : Tag.fromJson(asT<Map<String, dynamic>>(jsonRes['tag'])!),
        source: asT<Object?>(jsonRes['source']),
        extInfo: asT<Object?>(jsonRes['extInfo']),
        commentVideoVO: jsonRes['commentVideoVO'] == null
            ? null
            : CommentVideoVO.fromJson(
                asT<Map<String, dynamic>>(jsonRes['commentVideoVO'])!),
      );

  User? user;
  Object? beReplied;
  int? commentId;
  String? content;
  int? status;
  int? time;
  int? likedCount;
  bool? liked;
  Object? expressionUrl;
  int? parentCommentId;
  bool? repliedMark;
  Object? pendantData;
  ShowFloorComment? showFloorComment;
  Decoration? decoration;
  int? commentLocationType;
  Object? args;
  Tag? tag;
  Object? source;
  Object? extInfo;
  CommentVideoVO? commentVideoVO;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user,
        'beReplied': beReplied,
        'commentId': commentId,
        'content': content,
        'status': status,
        'time': time,
        'likedCount': likedCount,
        'liked': liked,
        'expressionUrl': expressionUrl,
        'parentCommentId': parentCommentId,
        'repliedMark': repliedMark,
        'pendantData': pendantData,
        'showFloorComment': showFloorComment,
        'decoration': decoration,
        'commentLocationType': commentLocationType,
        'args': args,
        'tag': tag,
        'source': source,
        'extInfo': extInfo,
        'commentVideoVO': commentVideoVO,
      };

  Comments clone() => Comments.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class User {
  User({
    this.avatarDetail,
    this.commonIdentity,
    this.locationInfo,
    this.liveInfo,
    this.followed,
    this.vipRights,
    this.relationTag,
    this.anonym,
    this.userId,
    this.userType,
    this.nickname,
    this.avatarUrl,
    this.authStatus,
    this.expertTags,
    this.experts,
    this.vipType,
    this.remarkName,
    this.isHug,
  });

  factory User.fromJson(Map<String, dynamic> jsonRes) => User(
        avatarDetail: asT<Object?>(jsonRes['avatarDetail']),
        commonIdentity: asT<Object?>(jsonRes['commonIdentity']),
        locationInfo: asT<Object?>(jsonRes['locationInfo']),
        liveInfo: asT<Object?>(jsonRes['liveInfo']),
        followed: asT<bool?>(jsonRes['followed']),
        vipRights: jsonRes['vipRights'] == null
            ? null
            : VipRights.fromJson(
                asT<Map<String, dynamic>>(jsonRes['vipRights'])!),
        relationTag: asT<Object?>(jsonRes['relationTag']),
        anonym: asT<int?>(jsonRes['anonym']),
        userId: asT<int?>(jsonRes['userId']),
        userType: asT<int?>(jsonRes['userType']),
        nickname: asT<String?>(jsonRes['nickname']),
        avatarUrl: asT<String?>(jsonRes['avatarUrl']),
        authStatus: asT<int?>(jsonRes['authStatus']),
        expertTags: asT<Object?>(jsonRes['expertTags']),
        experts: asT<Object?>(jsonRes['experts']),
        vipType: asT<int?>(jsonRes['vipType']),
        remarkName: asT<Object?>(jsonRes['remarkName']),
        isHug: asT<bool?>(jsonRes['isHug']),
      );

  Object? avatarDetail;
  Object? commonIdentity;
  Object? locationInfo;
  Object? liveInfo;
  bool? followed;
  VipRights? vipRights;
  Object? relationTag;
  int? anonym;
  int? userId;
  int? userType;
  String? nickname;
  String? avatarUrl;
  int? authStatus;
  Object? expertTags;
  Object? experts;
  int? vipType;
  Object? remarkName;
  bool? isHug;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'avatarDetail': avatarDetail,
        'commonIdentity': commonIdentity,
        'locationInfo': locationInfo,
        'liveInfo': liveInfo,
        'followed': followed,
        'vipRights': vipRights,
        'relationTag': relationTag,
        'anonym': anonym,
        'userId': userId,
        'userType': userType,
        'nickname': nickname,
        'avatarUrl': avatarUrl,
        'authStatus': authStatus,
        'expertTags': expertTags,
        'experts': experts,
        'vipType': vipType,
        'remarkName': remarkName,
        'isHug': isHug,
      };

  User clone() =>
      User.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class VipRights {
  VipRights({
    this.associator,
    this.musicPackage,
    this.redVipAnnualCount,
    this.redVipLevel,
  });

  factory VipRights.fromJson(Map<String, dynamic> jsonRes) => VipRights(
        associator: jsonRes['associator'] == null
            ? null
            : Associator.fromJson(
                asT<Map<String, dynamic>>(jsonRes['associator'])!),
        musicPackage: asT<Object?>(jsonRes['musicPackage']),
        redVipAnnualCount: asT<int?>(jsonRes['redVipAnnualCount']),
        redVipLevel: asT<int?>(jsonRes['redVipLevel']),
      );

  Associator? associator;
  Object? musicPackage;
  int? redVipAnnualCount;
  int? redVipLevel;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'associator': associator,
        'musicPackage': musicPackage,
        'redVipAnnualCount': redVipAnnualCount,
        'redVipLevel': redVipLevel,
      };

  VipRights clone() => VipRights.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Associator {
  Associator({
    this.vipCode,
    this.rights,
  });

  factory Associator.fromJson(Map<String, dynamic> jsonRes) => Associator(
        vipCode: asT<int?>(jsonRes['vipCode']),
        rights: asT<bool?>(jsonRes['rights']),
      );

  int? vipCode;
  bool? rights;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'vipCode': vipCode,
        'rights': rights,
      };

  Associator clone() => Associator.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class ShowFloorComment {
  ShowFloorComment({
    this.replyCount,
    this.comments,
    this.showReplyCount,
    this.topCommentIds,
    this.target,
  });

  factory ShowFloorComment.fromJson(Map<String, dynamic> jsonRes) =>
      ShowFloorComment(
        replyCount: asT<int?>(jsonRes['replyCount']),
        comments: asT<Object?>(jsonRes['comments']),
        showReplyCount: asT<bool?>(jsonRes['showReplyCount']),
        topCommentIds: asT<Object?>(jsonRes['topCommentIds']),
        target: asT<Object?>(jsonRes['target']),
      );

  int? replyCount;
  Object? comments;
  bool? showReplyCount;
  Object? topCommentIds;
  Object? target;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'replyCount': replyCount,
        'comments': comments,
        'showReplyCount': showReplyCount,
        'topCommentIds': topCommentIds,
        'target': target,
      };

  ShowFloorComment clone() => ShowFloorComment.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Decoration {
  Decoration({
    this.repliedByAuthorCount,
  });

  factory Decoration.fromJson(Map<String, dynamic> jsonRes) => Decoration(
        repliedByAuthorCount: asT<int?>(jsonRes['repliedByAuthorCount']),
      );

  int? repliedByAuthorCount;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'repliedByAuthorCount': repliedByAuthorCount,
      };

  Decoration clone() => Decoration.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Tag {
  Tag({
    this.datas,
    this.relatedCommentIds,
  });

  factory Tag.fromJson(Map<String, dynamic> jsonRes) => Tag(
        datas: asT<Object?>(jsonRes['datas']),
        relatedCommentIds: asT<Object?>(jsonRes['relatedCommentIds']),
      );

  Object? datas;
  Object? relatedCommentIds;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'datas': datas,
        'relatedCommentIds': relatedCommentIds,
      };

  Tag clone() =>
      Tag.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class CommentVideoVO {
  CommentVideoVO({
    this.showCreationEntrance,
    this.allowCreation,
    this.creationOrpheusUrl,
    this.playOrpheusUrl,
    this.videoCount,
    this.forbidCreationText,
  });

  factory CommentVideoVO.fromJson(Map<String, dynamic> jsonRes) =>
      CommentVideoVO(
        showCreationEntrance: asT<bool?>(jsonRes['showCreationEntrance']),
        allowCreation: asT<bool?>(jsonRes['allowCreation']),
        creationOrpheusUrl: asT<String?>(jsonRes['creationOrpheusUrl']),
        playOrpheusUrl: asT<String?>(jsonRes['playOrpheusUrl']),
        videoCount: asT<int?>(jsonRes['videoCount']),
        forbidCreationText: asT<String?>(jsonRes['forbidCreationText']),
      );

  bool? showCreationEntrance;
  bool? allowCreation;
  String? creationOrpheusUrl;
  String? playOrpheusUrl;
  int? videoCount;
  String? forbidCreationText;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'showCreationEntrance': showCreationEntrance,
        'allowCreation': allowCreation,
        'creationOrpheusUrl': creationOrpheusUrl,
        'playOrpheusUrl': playOrpheusUrl,
        'videoCount': videoCount,
        'forbidCreationText': forbidCreationText,
      };

  CommentVideoVO clone() => CommentVideoVO.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class SortTypeList {
  SortTypeList({
    this.sortType,
    this.sortTypeName,
    this.target,
  });

  factory SortTypeList.fromJson(Map<String, dynamic> jsonRes) => SortTypeList(
        sortType: asT<int?>(jsonRes['sortType']),
        sortTypeName: asT<String?>(jsonRes['sortTypeName']),
        target: asT<String?>(jsonRes['target']),
      );

  int? sortType;
  String? sortTypeName;
  String? target;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sortType': sortType,
        'sortTypeName': sortTypeName,
        'target': target,
      };

  SortTypeList clone() => SortTypeList.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
