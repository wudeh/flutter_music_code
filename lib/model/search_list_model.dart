import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class searchListModel {
  searchListModel({
    this.result,
    this.code,
  });

  factory searchListModel.fromJson(Map<String, dynamic> jsonRes) =>
      searchListModel(
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

  searchListModel clone() => searchListModel
      .fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Result {
  Result({
    this.playlists,
    this.hasMore,
    this.playlistCount,
  });

  factory Result.fromJson(Map<String, dynamic> jsonRes) {
    final List<Playlists>? playlists =
        jsonRes['playlists'] is List ? <Playlists>[] : null;
    if (playlists != null) {
      for (final dynamic item in jsonRes['playlists']!) {
        if (item != null) {
          playlists.add(Playlists.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Result(
      playlists: playlists,
      hasMore: asT<bool?>(jsonRes['hasMore']),
      playlistCount: asT<int?>(jsonRes['playlistCount']),
    );
  }

  List<Playlists>? playlists;
  bool? hasMore;
  int? playlistCount;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'playlists': playlists,
        'hasMore': hasMore,
        'playlistCount': playlistCount,
      };

  Result clone() =>
      Result.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Playlists {
  Playlists({
    this.id,
    this.name,
    this.coverImgUrl,
    this.creator,
    this.subscribed,
    this.trackCount,
    this.userId,
    this.playCount,
    this.bookCount,
    this.specialType,
    this.officialTags,
    this.description,
    this.highQuality,
    this.track,
    this.alg,
  });

  factory Playlists.fromJson(Map<String, dynamic> jsonRes) => Playlists(
        id: asT<int?>(jsonRes['id']),
        name: asT<String?>(jsonRes['name']),
        coverImgUrl: asT<String?>(jsonRes['coverImgUrl']),
        creator: jsonRes['creator'] == null
            ? null
            : Creator.fromJson(asT<Map<String, dynamic>>(jsonRes['creator'])!),
        subscribed: asT<bool?>(jsonRes['subscribed']),
        trackCount: asT<int?>(jsonRes['trackCount']),
        userId: asT<int?>(jsonRes['userId']),
        playCount: asT<int?>(jsonRes['playCount']),
        bookCount: asT<int?>(jsonRes['bookCount']),
        specialType: asT<int?>(jsonRes['specialType']),
        officialTags: asT<Object?>(jsonRes['officialTags']),
        description: asT<String?>(jsonRes['description']),
        highQuality: asT<bool?>(jsonRes['highQuality']),
        track: jsonRes['track'] == null
            ? null
            : Track.fromJson(asT<Map<String, dynamic>>(jsonRes['track'])!),
        alg: asT<String?>(jsonRes['alg']),
      );

  int? id;
  String? name;
  String? coverImgUrl;
  Creator? creator;
  bool? subscribed;
  int? trackCount;
  int? userId;
  int? playCount;
  int? bookCount;
  int? specialType;
  Object? officialTags;
  String? description;
  bool? highQuality;
  Track? track;
  String? alg;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'coverImgUrl': coverImgUrl,
        'creator': creator,
        'subscribed': subscribed,
        'trackCount': trackCount,
        'userId': userId,
        'playCount': playCount,
        'bookCount': bookCount,
        'specialType': specialType,
        'officialTags': officialTags,
        'description': description,
        'highQuality': highQuality,
        'track': track,
        'alg': alg,
      };

  Playlists clone() => Playlists.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Creator {
  Creator({
    this.nickname,
    this.userId,
    this.userType,
    this.avatarUrl,
    this.authStatus,
    this.expertTags,
    this.experts,
  });

  factory Creator.fromJson(Map<String, dynamic> jsonRes) => Creator(
        nickname: asT<String?>(jsonRes['nickname']),
        userId: asT<int?>(jsonRes['userId']),
        userType: asT<int?>(jsonRes['userType']),
        avatarUrl: asT<String?>(jsonRes['avatarUrl']),
        authStatus: asT<int?>(jsonRes['authStatus']),
        expertTags: asT<Object?>(jsonRes['expertTags']),
        experts: asT<Object?>(jsonRes['experts']),
      );

  String? nickname;
  int? userId;
  int? userType;
  String? avatarUrl;
  int? authStatus;
  Object? expertTags;
  Object? experts;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'nickname': nickname,
        'userId': userId,
        'userType': userType,
        'avatarUrl': avatarUrl,
        'authStatus': authStatus,
        'expertTags': expertTags,
        'experts': experts,
      };

  Creator clone() => Creator.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Track {
  Track({
    this.name,
    this.id,
    this.position,
    this.alias,
    this.status,
    this.fee,
    this.copyrightId,
    this.disc,
    this.no,
    this.artists,
    this.album,
    this.starred,
    this.popularity,
    this.score,
    this.starredNum,
    this.duration,
    this.playedNum,
    this.dayPlays,
    this.hearTime,
    this.ringtone,
    this.crbt,
    this.audition,
    this.copyFrom,
    this.commentThreadId,
    this.rtUrl,
    this.ftype,
    this.rtUrls,
    this.copyright,
    this.mvid,
    this.hMusic,
    this.mMusic,
    this.lMusic,
    this.bMusic,
    this.rtype,
    this.rurl,
    this.mp3Url,
  });

  factory Track.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? alias = jsonRes['alias'] is List ? <Object>[] : null;
    if (alias != null) {
      for (final dynamic item in jsonRes['alias']!) {
        if (item != null) {
          alias.add(asT<Object>(item)!);
        }
      }
    }

    final List<Artists>? artists =
        jsonRes['artists'] is List ? <Artists>[] : null;
    if (artists != null) {
      for (final dynamic item in jsonRes['artists']!) {
        if (item != null) {
          artists.add(Artists.fromJson(asT<Map<String, dynamic>>(item)!));
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
    return Track(
      name: asT<String?>(jsonRes['name']),
      id: asT<int?>(jsonRes['id']),
      position: asT<int?>(jsonRes['position']),
      alias: alias,
      status: asT<int?>(jsonRes['status']),
      fee: asT<int?>(jsonRes['fee']),
      copyrightId: asT<int?>(jsonRes['copyrightId']),
      disc: asT<String?>(jsonRes['disc']),
      no: asT<int?>(jsonRes['no']),
      artists: artists,
      album: jsonRes['album'] == null
          ? null
          : Album.fromJson(asT<Map<String, dynamic>>(jsonRes['album'])!),
      starred: asT<bool?>(jsonRes['starred']),
      popularity: asT<int?>(jsonRes['popularity']),
      score: asT<int?>(jsonRes['score']),
      starredNum: asT<int?>(jsonRes['starredNum']),
      duration: asT<int?>(jsonRes['duration']),
      playedNum: asT<int?>(jsonRes['playedNum']),
      dayPlays: asT<int?>(jsonRes['dayPlays']),
      hearTime: asT<int?>(jsonRes['hearTime']),
      ringtone: asT<String?>(jsonRes['ringtone']),
      crbt: asT<Object?>(jsonRes['crbt']),
      audition: asT<Object?>(jsonRes['audition']),
      copyFrom: asT<String?>(jsonRes['copyFrom']),
      commentThreadId: asT<String?>(jsonRes['commentThreadId']),
      rtUrl: asT<Object?>(jsonRes['rtUrl']),
      ftype: asT<int?>(jsonRes['ftype']),
      rtUrls: rtUrls,
      copyright: asT<int?>(jsonRes['copyright']),
      mvid: asT<int?>(jsonRes['mvid']),
      hMusic: jsonRes['hMusic'] == null
          ? null
          : HMusic.fromJson(asT<Map<String, dynamic>>(jsonRes['hMusic'])!),
      mMusic: jsonRes['mMusic'] == null
          ? null
          : MMusic.fromJson(asT<Map<String, dynamic>>(jsonRes['mMusic'])!),
      lMusic: jsonRes['lMusic'] == null
          ? null
          : LMusic.fromJson(asT<Map<String, dynamic>>(jsonRes['lMusic'])!),
      bMusic: jsonRes['bMusic'] == null
          ? null
          : BMusic.fromJson(asT<Map<String, dynamic>>(jsonRes['bMusic'])!),
      rtype: asT<int?>(jsonRes['rtype']),
      rurl: asT<Object?>(jsonRes['rurl']),
      mp3Url: asT<Object?>(jsonRes['mp3Url']),
    );
  }

  String? name;
  int? id;
  int? position;
  List<Object>? alias;
  int? status;
  int? fee;
  int? copyrightId;
  String? disc;
  int? no;
  List<Artists>? artists;
  Album? album;
  bool? starred;
  int? popularity;
  int? score;
  int? starredNum;
  int? duration;
  int? playedNum;
  int? dayPlays;
  int? hearTime;
  String? ringtone;
  Object? crbt;
  Object? audition;
  String? copyFrom;
  String? commentThreadId;
  Object? rtUrl;
  int? ftype;
  List<Object>? rtUrls;
  int? copyright;
  int? mvid;
  HMusic? hMusic;
  MMusic? mMusic;
  LMusic? lMusic;
  BMusic? bMusic;
  int? rtype;
  Object? rurl;
  Object? mp3Url;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'position': position,
        'alias': alias,
        'status': status,
        'fee': fee,
        'copyrightId': copyrightId,
        'disc': disc,
        'no': no,
        'artists': artists,
        'album': album,
        'starred': starred,
        'popularity': popularity,
        'score': score,
        'starredNum': starredNum,
        'duration': duration,
        'playedNum': playedNum,
        'dayPlays': dayPlays,
        'hearTime': hearTime,
        'ringtone': ringtone,
        'crbt': crbt,
        'audition': audition,
        'copyFrom': copyFrom,
        'commentThreadId': commentThreadId,
        'rtUrl': rtUrl,
        'ftype': ftype,
        'rtUrls': rtUrls,
        'copyright': copyright,
        'mvid': mvid,
        'hMusic': hMusic,
        'mMusic': mMusic,
        'lMusic': lMusic,
        'bMusic': bMusic,
        'rtype': rtype,
        'rurl': rurl,
        'mp3Url': mp3Url,
      };

  Track clone() =>
      Track.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Artists {
  Artists({
    this.name,
    this.id,
    this.picId,
    this.img1v1Id,
    this.briefDesc,
    this.picUrl,
    this.img1v1Url,
    this.albumSize,
    this.alias,
    this.trans,
    this.musicSize,
  });

  factory Artists.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? alias = jsonRes['alias'] is List ? <Object>[] : null;
    if (alias != null) {
      for (final dynamic item in jsonRes['alias']!) {
        if (item != null) {
          alias.add(asT<Object>(item)!);
        }
      }
    }
    return Artists(
      name: asT<String?>(jsonRes['name']),
      id: asT<int?>(jsonRes['id']),
      picId: asT<int?>(jsonRes['picId']),
      img1v1Id: asT<int?>(jsonRes['img1v1Id']),
      briefDesc: asT<String?>(jsonRes['briefDesc']),
      picUrl: asT<String?>(jsonRes['picUrl']),
      img1v1Url: asT<String?>(jsonRes['img1v1Url']),
      albumSize: asT<int?>(jsonRes['albumSize']),
      alias: alias,
      trans: asT<String?>(jsonRes['trans']),
      musicSize: asT<int?>(jsonRes['musicSize']),
    );
  }

  String? name;
  int? id;
  int? picId;
  int? img1v1Id;
  String? briefDesc;
  String? picUrl;
  String? img1v1Url;
  int? albumSize;
  List<Object>? alias;
  String? trans;
  int? musicSize;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'picId': picId,
        'img1v1Id': img1v1Id,
        'briefDesc': briefDesc,
        'picUrl': picUrl,
        'img1v1Url': img1v1Url,
        'albumSize': albumSize,
        'alias': alias,
        'trans': trans,
        'musicSize': musicSize,
      };

  Artists clone() => Artists.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Album {
  Album({
    this.name,
    this.id,
    this.type,
    this.size,
    this.picId,
    this.blurPicUrl,
    this.companyId,
    this.pic,
    this.picUrl,
    this.publishTime,
    this.description,
    this.tags,
    this.company,
    this.briefDesc,
    this.artist,
    this.songs,
    this.alias,
    this.status,
    this.copyrightId,
    this.commentThreadId,
    this.artists,
    this.picidStr,
  });

  factory Album.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? songs = jsonRes['songs'] is List ? <Object>[] : null;
    if (songs != null) {
      for (final dynamic item in jsonRes['songs']!) {
        if (item != null) {
          songs.add(asT<Object>(item)!);
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

    final List<Artists>? artists =
        jsonRes['artists'] is List ? <Artists>[] : null;
    if (artists != null) {
      for (final dynamic item in jsonRes['artists']!) {
        if (item != null) {
          artists.add(Artists.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Album(
      name: asT<String?>(jsonRes['name']),
      id: asT<int?>(jsonRes['id']),
      type: asT<String?>(jsonRes['type']),
      size: asT<int?>(jsonRes['size']),
      picId: asT<int?>(jsonRes['picId']),
      blurPicUrl: asT<String?>(jsonRes['blurPicUrl']),
      companyId: asT<int?>(jsonRes['companyId']),
      pic: asT<int?>(jsonRes['pic']),
      picUrl: asT<String?>(jsonRes['picUrl']),
      publishTime: asT<int?>(jsonRes['publishTime']),
      description: asT<String?>(jsonRes['description']),
      tags: asT<String?>(jsonRes['tags']),
      company: asT<String?>(jsonRes['company']),
      briefDesc: asT<String?>(jsonRes['briefDesc']),
      artist: jsonRes['artist'] == null
          ? null
          : Artist.fromJson(asT<Map<String, dynamic>>(jsonRes['artist'])!),
      songs: songs,
      alias: alias,
      status: asT<int?>(jsonRes['status']),
      copyrightId: asT<int?>(jsonRes['copyrightId']),
      commentThreadId: asT<String?>(jsonRes['commentThreadId']),
      artists: artists,
      picidStr: asT<String?>(jsonRes['picId_str']),
    );
  }

  String? name;
  int? id;
  String? type;
  int? size;
  int? picId;
  String? blurPicUrl;
  int? companyId;
  int? pic;
  String? picUrl;
  int? publishTime;
  String? description;
  String? tags;
  String? company;
  String? briefDesc;
  Artist? artist;
  List<Object>? songs;
  List<Object>? alias;
  int? status;
  int? copyrightId;
  String? commentThreadId;
  List<Artists>? artists;
  String? picidStr;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'type': type,
        'size': size,
        'picId': picId,
        'blurPicUrl': blurPicUrl,
        'companyId': companyId,
        'pic': pic,
        'picUrl': picUrl,
        'publishTime': publishTime,
        'description': description,
        'tags': tags,
        'company': company,
        'briefDesc': briefDesc,
        'artist': artist,
        'songs': songs,
        'alias': alias,
        'status': status,
        'copyrightId': copyrightId,
        'commentThreadId': commentThreadId,
        'artists': artists,
        'picId_str': picidStr,
      };

  Album clone() =>
      Album.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Artist {
  Artist({
    this.name,
    this.id,
    this.picId,
    this.img1v1Id,
    this.briefDesc,
    this.picUrl,
    this.img1v1Url,
    this.albumSize,
    this.alias,
    this.trans,
    this.musicSize,
  });

  factory Artist.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object>? alias = jsonRes['alias'] is List ? <Object>[] : null;
    if (alias != null) {
      for (final dynamic item in jsonRes['alias']!) {
        if (item != null) {
          alias.add(asT<Object>(item)!);
        }
      }
    }
    return Artist(
      name: asT<String?>(jsonRes['name']),
      id: asT<int?>(jsonRes['id']),
      picId: asT<int?>(jsonRes['picId']),
      img1v1Id: asT<int?>(jsonRes['img1v1Id']),
      briefDesc: asT<String?>(jsonRes['briefDesc']),
      picUrl: asT<String?>(jsonRes['picUrl']),
      img1v1Url: asT<String?>(jsonRes['img1v1Url']),
      albumSize: asT<int?>(jsonRes['albumSize']),
      alias: alias,
      trans: asT<String?>(jsonRes['trans']),
      musicSize: asT<int?>(jsonRes['musicSize']),
    );
  }

  String? name;
  int? id;
  int? picId;
  int? img1v1Id;
  String? briefDesc;
  String? picUrl;
  String? img1v1Url;
  int? albumSize;
  List<Object>? alias;
  String? trans;
  int? musicSize;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'picId': picId,
        'img1v1Id': img1v1Id,
        'briefDesc': briefDesc,
        'picUrl': picUrl,
        'img1v1Url': img1v1Url,
        'albumSize': albumSize,
        'alias': alias,
        'trans': trans,
        'musicSize': musicSize,
      };

  Artist clone() =>
      Artist.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class HMusic {
  HMusic({
    this.name,
    this.id,
    this.size,
    this.extension,
    this.sr,
    this.dfsId,
    this.bitrate,
    this.playTime,
    this.volumeDelta,
  });

  factory HMusic.fromJson(Map<String, dynamic> jsonRes) => HMusic(
        name: asT<Object?>(jsonRes['name']),
        id: asT<int?>(jsonRes['id']),
        size: asT<int?>(jsonRes['size']),
        extension: asT<String?>(jsonRes['extension']),
        sr: asT<int?>(jsonRes['sr']),
        dfsId: asT<int?>(jsonRes['dfsId']),
        bitrate: asT<int?>(jsonRes['bitrate']),
        playTime: asT<int?>(jsonRes['playTime']),
        volumeDelta: asT<int?>(jsonRes['volumeDelta']),
      );

  Object? name;
  int? id;
  int? size;
  String? extension;
  int? sr;
  int? dfsId;
  int? bitrate;
  int? playTime;
  int? volumeDelta;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'size': size,
        'extension': extension,
        'sr': sr,
        'dfsId': dfsId,
        'bitrate': bitrate,
        'playTime': playTime,
        'volumeDelta': volumeDelta,
      };

  HMusic clone() =>
      HMusic.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class MMusic {
  MMusic({
    this.name,
    this.id,
    this.size,
    this.extension,
    this.sr,
    this.dfsId,
    this.bitrate,
    this.playTime,
    this.volumeDelta,
  });

  factory MMusic.fromJson(Map<String, dynamic> jsonRes) => MMusic(
        name: asT<Object?>(jsonRes['name']),
        id: asT<int?>(jsonRes['id']),
        size: asT<int?>(jsonRes['size']),
        extension: asT<String?>(jsonRes['extension']),
        sr: asT<int?>(jsonRes['sr']),
        dfsId: asT<int?>(jsonRes['dfsId']),
        bitrate: asT<int?>(jsonRes['bitrate']),
        playTime: asT<int?>(jsonRes['playTime']),
        volumeDelta: asT<int?>(jsonRes['volumeDelta']),
      );

  Object? name;
  int? id;
  int? size;
  String? extension;
  int? sr;
  int? dfsId;
  int? bitrate;
  int? playTime;
  int? volumeDelta;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'size': size,
        'extension': extension,
        'sr': sr,
        'dfsId': dfsId,
        'bitrate': bitrate,
        'playTime': playTime,
        'volumeDelta': volumeDelta,
      };

  MMusic clone() =>
      MMusic.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class LMusic {
  LMusic({
    this.name,
    this.id,
    this.size,
    this.extension,
    this.sr,
    this.dfsId,
    this.bitrate,
    this.playTime,
    this.volumeDelta,
  });

  factory LMusic.fromJson(Map<String, dynamic> jsonRes) => LMusic(
        name: asT<Object?>(jsonRes['name']),
        id: asT<int?>(jsonRes['id']),
        size: asT<int?>(jsonRes['size']),
        extension: asT<String?>(jsonRes['extension']),
        sr: asT<int?>(jsonRes['sr']),
        dfsId: asT<int?>(jsonRes['dfsId']),
        bitrate: asT<int?>(jsonRes['bitrate']),
        playTime: asT<int?>(jsonRes['playTime']),
        volumeDelta: asT<int?>(jsonRes['volumeDelta']),
      );

  Object? name;
  int? id;
  int? size;
  String? extension;
  int? sr;
  int? dfsId;
  int? bitrate;
  int? playTime;
  int? volumeDelta;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'size': size,
        'extension': extension,
        'sr': sr,
        'dfsId': dfsId,
        'bitrate': bitrate,
        'playTime': playTime,
        'volumeDelta': volumeDelta,
      };

  LMusic clone() =>
      LMusic.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class BMusic {
  BMusic({
    this.name,
    this.id,
    this.size,
    this.extension,
    this.sr,
    this.dfsId,
    this.bitrate,
    this.playTime,
    this.volumeDelta,
  });

  factory BMusic.fromJson(Map<String, dynamic> jsonRes) => BMusic(
        name: asT<Object?>(jsonRes['name']),
        id: asT<int?>(jsonRes['id']),
        size: asT<int?>(jsonRes['size']),
        extension: asT<String?>(jsonRes['extension']),
        sr: asT<int?>(jsonRes['sr']),
        dfsId: asT<int?>(jsonRes['dfsId']),
        bitrate: asT<int?>(jsonRes['bitrate']),
        playTime: asT<int?>(jsonRes['playTime']),
        volumeDelta: asT<int?>(jsonRes['volumeDelta']),
      );

  Object? name;
  int? id;
  int? size;
  String? extension;
  int? sr;
  int? dfsId;
  int? bitrate;
  int? playTime;
  int? volumeDelta;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'size': size,
        'extension': extension,
        'sr': sr,
        'dfsId': dfsId,
        'bitrate': bitrate,
        'playTime': playTime,
        'volumeDelta': volumeDelta,
      };

  BMusic clone() =>
      BMusic.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
