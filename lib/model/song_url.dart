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

class SongUrlModel {
  SongUrlModel({
    this.data,
    this.code,
  });

  factory SongUrlModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<Data>? data = jsonRes['data'] is List ? <Data>[] : null;
    if (data != null) {
      for (final dynamic item in jsonRes['data']!) {
        if (item != null) {
          tryCatch(() {
            data.add(Data.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return SongUrlModel(
      data: data,
      code: asT<int?>(jsonRes['code']),
    );
  }

  List<Data>? data;
  int? code;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
        'code': code,
      };

  SongUrlModel clone() => SongUrlModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class Data {
  Data({
    this.id,
    this.url,
    this.br,
    this.size,
    this.md5,
    this.code,
    this.expi,
    this.type,
    this.gain,
    this.fee,
    this.uf,
    this.payed,
    this.flag,
    this.canExtend,
    this.freeTrialInfo,
    this.level,
    this.encodeType,
    this.freeTrialPrivilege,
    this.freeTimeTrialPrivilege,
    this.urlSource,
  });

  factory Data.fromJson(Map<String, dynamic> jsonRes) => Data(
        id: asT<int?>(jsonRes['id']),
        url: asT<String?>(jsonRes['url']),
        br: asT<int?>(jsonRes['br']),
        size: asT<int?>(jsonRes['size']),
        md5: asT<String?>(jsonRes['md5']),
        code: asT<int?>(jsonRes['code']),
        expi: asT<int?>(jsonRes['expi']),
        type: asT<String?>(jsonRes['type']),
        gain: asT<int?>(jsonRes['gain']),
        fee: asT<int?>(jsonRes['fee']),
        uf: asT<Object?>(jsonRes['uf']),
        payed: asT<int?>(jsonRes['payed']),
        flag: asT<int?>(jsonRes['flag']),
        canExtend: asT<bool?>(jsonRes['canExtend']),
        freeTrialInfo: asT<Object?>(jsonRes['freeTrialInfo']),
        level: asT<String?>(jsonRes['level']),
        encodeType: asT<String?>(jsonRes['encodeType']),
        freeTrialPrivilege: jsonRes['freeTrialPrivilege'] == null
            ? null
            : FreeTrialPrivilege.fromJson(
                asT<Map<String, dynamic>>(jsonRes['freeTrialPrivilege'])!),
        freeTimeTrialPrivilege: jsonRes['freeTimeTrialPrivilege'] == null
            ? null
            : FreeTimeTrialPrivilege.fromJson(
                asT<Map<String, dynamic>>(jsonRes['freeTimeTrialPrivilege'])!),
        urlSource: asT<int?>(jsonRes['urlSource']),
      );

  int? id;
  String? url;
  int? br;
  int? size;
  String? md5;
  int? code;
  int? expi;
  String? type;
  int? gain;
  int? fee;
  Object? uf;
  int? payed;
  int? flag;
  bool? canExtend;
  Object? freeTrialInfo;
  String? level;
  String? encodeType;
  FreeTrialPrivilege? freeTrialPrivilege;
  FreeTimeTrialPrivilege? freeTimeTrialPrivilege;
  int? urlSource;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'url': url,
        'br': br,
        'size': size,
        'md5': md5,
        'code': code,
        'expi': expi,
        'type': type,
        'gain': gain,
        'fee': fee,
        'uf': uf,
        'payed': payed,
        'flag': flag,
        'canExtend': canExtend,
        'freeTrialInfo': freeTrialInfo,
        'level': level,
        'encodeType': encodeType,
        'freeTrialPrivilege': freeTrialPrivilege,
        'freeTimeTrialPrivilege': freeTimeTrialPrivilege,
        'urlSource': urlSource,
      };

  Data clone() =>
      Data.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class FreeTrialPrivilege {
  FreeTrialPrivilege({
    this.resConsumable,
    this.userConsumable,
    this.listenType,
  });

  factory FreeTrialPrivilege.fromJson(Map<String, dynamic> jsonRes) =>
      FreeTrialPrivilege(
        resConsumable: asT<bool?>(jsonRes['resConsumable']),
        userConsumable: asT<bool?>(jsonRes['userConsumable']),
        listenType: asT<Object?>(jsonRes['listenType']),
      );

  bool? resConsumable;
  bool? userConsumable;
  Object? listenType;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'resConsumable': resConsumable,
        'userConsumable': userConsumable,
        'listenType': listenType,
      };

  FreeTrialPrivilege clone() => FreeTrialPrivilege.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

class FreeTimeTrialPrivilege {
  FreeTimeTrialPrivilege({
    this.resConsumable,
    this.userConsumable,
    this.type,
    this.remainTime,
  });

  factory FreeTimeTrialPrivilege.fromJson(Map<String, dynamic> jsonRes) =>
      FreeTimeTrialPrivilege(
        resConsumable: asT<bool?>(jsonRes['resConsumable']),
        userConsumable: asT<bool?>(jsonRes['userConsumable']),
        type: asT<int?>(jsonRes['type']),
        remainTime: asT<int?>(jsonRes['remainTime']),
      );

  bool? resConsumable;
  bool? userConsumable;
  int? type;
  int? remainTime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'resConsumable': resConsumable,
        'userConsumable': userConsumable,
        'type': type,
        'remainTime': remainTime,
      };

  FreeTimeTrialPrivilege clone() => FreeTimeTrialPrivilege.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
