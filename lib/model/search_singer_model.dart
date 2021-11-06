import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class searchSingerModel {
  searchSingerModel({
    this.result,
    this.code,
  });

  factory searchSingerModel.fromJson(Map<String, dynamic> jsonRes) =>
      searchSingerModel(
        result: jsonRes['result'] == null
            ? null
            : Result.fromJson(asT<Map<String, dynamic>>(jsonRes['result'])!),
        code: asT<int?>(jsonRes['code']),
      );

  Result? result;
  int? code;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'result': result,
        'code': code,
      };

  searchSingerModel clone() => searchSingerModel
      .fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Result {
  Result({
    this.artistCount,
    this.hasMore,
    this.artists,
  });

  factory Result.fromJson(Map<String, dynamic> jsonRes) {
    final List<singerArtists>? artists =
        jsonRes['artists'] is List ? <singerArtists>[] : null;
    if (artists != null) {
      for (final dynamic item in jsonRes['artists']!) {
        if (item != null) {
          artists.add(singerArtists.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Result(
      artistCount: asT<int?>(jsonRes['artistCount']),
      hasMore: asT<bool?>(jsonRes['hasMore']),
      artists: artists,
    );
  }

  int? artistCount;
  bool? hasMore;
  List<singerArtists>? artists;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'artistCount': artistCount,
        'hasMore': hasMore,
        'artists': artists,
      };

  Result clone() =>
      Result.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class singerArtists {
  singerArtists({
    this.id,
    this.name,
    this.picUrl,
    this.alias,
    this.albumSize,
    this.picId,
    this.img1v1Url,
    this.accountId,
    this.img1v1,
    this.mvSize,
    this.followed,
    this.alg,
    this.alia,
    this.trans,
  });

  factory singerArtists.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? alias = jsonRes['alias'] is List ? <String>[] : null;
    if (alias != null) {
      for (final dynamic item in jsonRes['alias']!) {
        if (item != null) {
          alias.add(asT<String>(item)!);
        }
      }
    }

    final List<String>? alia = jsonRes['alia'] is List ? <String>[] : null;
    if (alia != null) {
      for (final dynamic item in jsonRes['alia']!) {
        if (item != null) {
          alia.add(asT<String>(item)!);
        }
      }
    }
    return singerArtists(
      id: asT<int?>(jsonRes['id']),
      name: asT<String?>(jsonRes['name']),
      picUrl: asT<String?>(jsonRes['picUrl']),
      alias: alias,
      albumSize: asT<int?>(jsonRes['albumSize']),
      picId: asT<int?>(jsonRes['picId']),
      img1v1Url: asT<String?>(jsonRes['img1v1Url']),
      accountId: asT<int?>(jsonRes['accountId']),
      img1v1: asT<int?>(jsonRes['img1v1']),
      mvSize: asT<int?>(jsonRes['mvSize']),
      followed: asT<bool?>(jsonRes['followed']),
      alg: asT<String?>(jsonRes['alg']),
      alia: alia,
      trans: asT<Object?>(jsonRes['trans']),
    );
  }

  int? id;
  String? name;
  String? picUrl;
  List<String>? alias;
  int? albumSize;
  int? picId;
  String? img1v1Url;
  int? accountId;
  int? img1v1;
  int? mvSize;
  bool? followed;
  String? alg;
  List<String>? alia;
  Object? trans;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'picUrl': picUrl,
        'alias': alias,
        'albumSize': albumSize,
        'picId': picId,
        'img1v1Url': img1v1Url,
        'accountId': accountId,
        'img1v1': img1v1,
        'mvSize': mvSize,
        'followed': followed,
        'alg': alg,
        'alia': alia,
        'trans': trans,
      };

  singerArtists clone() => singerArtists.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
