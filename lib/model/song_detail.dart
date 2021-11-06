import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class songDetail {
  songDetail({
    this.songs,
    this.privileges,
    this.code,
  });

  factory songDetail.fromJson(Map<String, dynamic> jsonRes) {
    final List<Songs>? songs = jsonRes['songs'] is List ? <Songs>[] : null;
    if (songs != null) {
      for (final dynamic item in jsonRes['songs']!) {
        if (item != null) {
          songs.add(Songs.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<Privileges>? privileges =
        jsonRes['privileges'] is List ? <Privileges>[] : null;
    if (privileges != null) {
      for (final dynamic item in jsonRes['privileges']!) {
        if (item != null) {
          privileges.add(Privileges.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return songDetail(
      songs: songs,
      privileges: privileges,
      code: asT<int?>(jsonRes['code']),
    );
  }

  List<Songs>? songs;
  List<Privileges>? privileges;
  int? code;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'songs': songs,
        'privileges': privileges,
        'code': code,
      };

  songDetail clone() => songDetail
      .fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Songs {
  Songs({
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
    this.resourceState,
    this.version,
    this.single,
    this.noCopyrightRcmd,
    this.mv,
    this.rtype,
    this.rurl,
    this.mst,
    this.cp,
    this.publishTime,
  });

  factory Songs.fromJson(Map<String, dynamic> jsonRes) {
    final List<Ar>? ar = jsonRes['ar'] is List ? <Ar>[] : null;
    if (ar != null) {
      for (final dynamic item in jsonRes['ar']!) {
        if (item != null) {
          ar.add(Ar.fromJson(asT<Map<String, dynamic>>(item)!));
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

    final List<Object>? rtUrls = jsonRes['rtUrls'] is List ? <Object>[] : null;
    if (rtUrls != null) {
      for (final dynamic item in jsonRes['rtUrls']!) {
        if (item != null) {
          rtUrls.add(asT<Object>(item)!);
        }
      }
    }
    return Songs(
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
      resourceState: asT<bool?>(jsonRes['resourceState']),
      version: asT<int?>(jsonRes['version']),
      single: asT<int?>(jsonRes['single']),
      noCopyrightRcmd: asT<Object?>(jsonRes['noCopyrightRcmd']),
      mv: asT<int?>(jsonRes['mv']),
      rtype: asT<int?>(jsonRes['rtype']),
      rurl: asT<Object?>(jsonRes['rurl']),
      mst: asT<int?>(jsonRes['mst']),
      cp: asT<int?>(jsonRes['cp']),
      publishTime: asT<int?>(jsonRes['publishTime']),
    );
  }

  String? name;
  int? id;
  int? pst;
  int? t;
  List<Ar>? ar;
  List<String>? alia;
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
  bool? resourceState;
  int? version;
  int? single;
  Object? noCopyrightRcmd;
  int? mv;
  int? rtype;
  Object? rurl;
  int? mst;
  int? cp;
  int? publishTime;

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
        'resourceState': resourceState,
        'version': version,
        'single': single,
        'noCopyrightRcmd': noCopyrightRcmd,
        'mv': mv,
        'rtype': rtype,
        'rurl': rurl,
        'mst': mst,
        'cp': cp,
        'publishTime': publishTime,
      };

  Songs clone() =>
      Songs.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
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
    this.picStr,
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
      picStr: asT<String?>(jsonRes['pic_str']),
      pic: asT<int?>(jsonRes['pic']),
    );
  }

  int? id;
  String? name;
  String? picUrl;
  List<Object>? tns;
  String? picStr;
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
        'pic_str': picStr,
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

class Privileges {
  Privileges({
    this.id,
    this.fee,
    this.payed,
    this.st,
    this.pl,
    this.dl,
    this.sp,
    this.cp,
    this.subp,
    this.cs,
    this.maxbr,
    this.fl,
    this.toast,
    this.flag,
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
      st: asT<int?>(jsonRes['st']),
      pl: asT<int?>(jsonRes['pl']),
      dl: asT<int?>(jsonRes['dl']),
      sp: asT<int?>(jsonRes['sp']),
      cp: asT<int?>(jsonRes['cp']),
      subp: asT<int?>(jsonRes['subp']),
      cs: asT<bool?>(jsonRes['cs']),
      maxbr: asT<int?>(jsonRes['maxbr']),
      fl: asT<int?>(jsonRes['fl']),
      toast: asT<bool?>(jsonRes['toast']),
      flag: asT<int?>(jsonRes['flag']),
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
  int? st;
  int? pl;
  int? dl;
  int? sp;
  int? cp;
  int? subp;
  bool? cs;
  int? maxbr;
  int? fl;
  bool? toast;
  int? flag;
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
        'st': st,
        'pl': pl,
        'dl': dl,
        'sp': sp,
        'cp': cp,
        'subp': subp,
        'cs': cs,
        'maxbr': maxbr,
        'fl': fl,
        'toast': toast,
        'flag': flag,
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
