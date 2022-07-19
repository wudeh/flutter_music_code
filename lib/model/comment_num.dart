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
    this.commentsTitle,
    this.comments,
    this.currentCommentTitle,
    this.currentComment,
    this.totalCount,
    this.hasMore,
    this.cursor,
    this.sortType,
    this.sortTypeList,
    this.style,
  });

  factory Data.fromJson(Map<String, dynamic> jsonRes) {
    final List<Comments>? comments =
        jsonRes['comments'] is List ? <Comments>[] : null;
    if (comments != null) {
      for (final dynamic item in jsonRes['comments']!) {
        if (item != null) {
          tryCatch(() {
            comments.add(Comments.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<SortTypeList>? sortTypeList =
        jsonRes['sortTypeList'] is List ? <SortTypeList>[] : null;
    if (sortTypeList != null) {
      for (final dynamic item in jsonRes['sortTypeList']!) {
        if (item != null) {
          tryCatch(() {
            sortTypeList
                .add(SortTypeList.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return Data(
      commentsTitle: asT<String?>(jsonRes['commentsTitle']),
      comments: comments,
      currentCommentTitle: asT<String?>(jsonRes['currentCommentTitle']),
      currentComment: asT<Object?>(jsonRes['currentComment']),
      totalCount: asT<int?>(jsonRes['totalCount']),
      hasMore: asT<bool?>(jsonRes['hasMore']),
      cursor: asT<String?>(jsonRes['cursor']),
      sortType: asT<int?>(jsonRes['sortType']),
      sortTypeList: sortTypeList,
      style: asT<String?>(jsonRes['style']),
    );
  }

  String? commentsTitle;
  List<Comments>? comments;
  String? currentCommentTitle;
  Object? currentComment;
  int? totalCount;
  bool? hasMore;
  String? cursor;
  int? sortType;
  List<SortTypeList>? sortTypeList;
  String? style;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'commentsTitle': commentsTitle,
        'comments': comments,
        'currentCommentTitle': currentCommentTitle,
        'currentComment': currentComment,
        'totalCount': totalCount,
        'hasMore': hasMore,
        'cursor': cursor,
        'sortType': sortType,
        'sortTypeList': sortTypeList,
        'style': style,
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
    this.richContent,
    this.status,
    this.time,
    this.timeStr,
    this.needDisplayTime,
    this.likedCount,
    this.replyCount,
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
    this.resourceSpecialType,
    this.extInfo,
    this.commentVideoVO,
    this.contentResource,
    this.contentPicNosKey,
    this.contentPicUrl,
    this.grade,
  });

  factory Comments.fromJson(Map<String, dynamic> jsonRes) => Comments(
        user: jsonRes['user'] == null
            ? null
            : User.fromJson(asT<Map<String, dynamic>>(jsonRes['user'])!),
        beReplied: asT<Object?>(jsonRes['beReplied']),
        commentId: asT<int?>(jsonRes['commentId']),
        content: asT<String?>(jsonRes['content']),
        richContent: asT<Object?>(jsonRes['richContent']),
        status: asT<int?>(jsonRes['status']),
        time: asT<int?>(jsonRes['time']),
        timeStr: asT<String?>(jsonRes['timeStr']),
        needDisplayTime: asT<bool?>(jsonRes['needDisplayTime']),
        likedCount: asT<int?>(jsonRes['likedCount']),
        replyCount: asT<int?>(jsonRes['replyCount']),
        liked: asT<bool?>(jsonRes['liked']),
        expressionUrl: asT<Object?>(jsonRes['expressionUrl']),
        parentCommentId: asT<int?>(jsonRes['parentCommentId']),
        repliedMark: asT<bool?>(jsonRes['repliedMark']),
        pendantData: jsonRes['pendantData'] == null
            ? null
            : PendantData.fromJson(
                asT<Map<String, dynamic>>(jsonRes['pendantData'])!),
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
        resourceSpecialType: asT<Object?>(jsonRes['resourceSpecialType']),
        extInfo: asT<Object?>(jsonRes['extInfo']),
        commentVideoVO: jsonRes['commentVideoVO'] == null
            ? null
            : CommentVideoVO.fromJson(
                asT<Map<String, dynamic>>(jsonRes['commentVideoVO'])!),
        contentResource: asT<Object?>(jsonRes['contentResource']),
        contentPicNosKey: asT<Object?>(jsonRes['contentPicNosKey']),
        contentPicUrl: asT<Object?>(jsonRes['contentPicUrl']),
        grade: asT<Object?>(jsonRes['grade']),
      );

  User? user;
  Object? beReplied;
  int? commentId;
  String? content;
  Object? richContent;
  int? status;
  int? time;
  String? timeStr;
  bool? needDisplayTime;
  int? likedCount;
  int? replyCount;
  bool? liked;
  Object? expressionUrl;
  int? parentCommentId;
  bool? repliedMark;
  PendantData? pendantData;
  ShowFloorComment? showFloorComment;
  Decoration? decoration;
  int? commentLocationType;
  Object? args;
  Tag? tag;
  Object? source;
  Object? resourceSpecialType;
  Object? extInfo;
  CommentVideoVO? commentVideoVO;
  Object? contentResource;
  Object? contentPicNosKey;
  Object? contentPicUrl;
  Object? grade;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user,
        'beReplied': beReplied,
        'commentId': commentId,
        'content': content,
        'richContent': richContent,
        'status': status,
        'time': time,
        'timeStr': timeStr,
        'needDisplayTime': needDisplayTime,
        'likedCount': likedCount,
        'replyCount': replyCount,
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
        'resourceSpecialType': resourceSpecialType,
        'extInfo': extInfo,
        'commentVideoVO': commentVideoVO,
        'contentResource': contentResource,
        'contentPicNosKey': contentPicNosKey,
        'contentPicUrl': contentPicUrl,
        'grade': grade,
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
        vipRights: asT<Object?>(jsonRes['vipRights']),
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
  Object? vipRights;
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

class PendantData {
  PendantData({
    this.id,
    this.imageUrl,
  });

  factory PendantData.fromJson(Map<String, dynamic> jsonRes) => PendantData(
        id: asT<int?>(jsonRes['id']),
        imageUrl: asT<String?>(jsonRes['imageUrl']),
      );

  int? id;
  String? imageUrl;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'imageUrl': imageUrl,
      };

  PendantData clone() => PendantData.fromJson(
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
    this.extDatas,
    this.relatedCommentIds,
  });

  factory Tag.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? extDatas =
        jsonRes['extDatas'] is List ? <Object>[] : null;
    if (extDatas != null) {
      for (final dynamic item in jsonRes['extDatas']!) {
        if (item != null) {
          tryCatch(() {
            extDatas.add(asT<Object>(item)!);
          });
        }
      }
    }
    return Tag(
      datas: asT<Object?>(jsonRes['datas']),
      extDatas: extDatas,
      relatedCommentIds: asT<Object?>(jsonRes['relatedCommentIds']),
    );
  }

  Object? datas;
  List<Object>? extDatas;
  Object? relatedCommentIds;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'datas': datas,
        'extDatas': extDatas,
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
        creationOrpheusUrl: asT<Object?>(jsonRes['creationOrpheusUrl']),
        playOrpheusUrl: asT<Object?>(jsonRes['playOrpheusUrl']),
        videoCount: asT<int?>(jsonRes['videoCount']),
        forbidCreationText: asT<String?>(jsonRes['forbidCreationText']),
      );

  bool? showCreationEntrance;
  bool? allowCreation;
  Object? creationOrpheusUrl;
  Object? playOrpheusUrl;
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
