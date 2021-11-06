import 'package:flutter/material.dart';

class SearchHot {
  int? code;
  List<Data>? data;
  String? message;

  SearchHot({this.code, this.data, this.message});

  SearchHot.fromJson(Map<String, dynamic> json) {
    if(json["code"] is int)
      this.code = json["code"];
    if(json["data"] is List)
      this.data = json["data"]==null ? null : (json["data"] as List).map((e)=>Data.fromJson(e)).toList();
    if(json["message"] is String)
      this.message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["code"] = this.code;
    if(this.data != null)
      data["data"] = this.data?.map((e)=>e.toJson()).toList();
    data["message"] = this.message;
    return data;
  }
}

class Data {
  String? searchWord;
  int? score;
  String? content;
  int? source;
  int? iconType;
  String? iconUrl;
  String? url;
  String? alg;

  Data({this.searchWord, this.score, this.content, this.source, this.iconType, this.iconUrl, this.url, this.alg});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["searchWord"] is String)
      this.searchWord = json["searchWord"];
    if(json["score"] is int)
      this.score = json["score"];
    if(json["content"] is String)
      this.content = json["content"];
    if(json["source"] is int)
      this.source = json["source"];
    if(json["iconType"] is int)
      this.iconType = json["iconType"];
    if(json["iconUrl"] is String)
      this.iconUrl = json["iconUrl"];
    if(json["url"] is String)
      this.url = json["url"];
    if(json["alg"] is String)
      this.alg = json["alg"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["searchWord"] = this.searchWord;
    data["score"] = this.score;
    data["content"] = this.content;
    data["source"] = this.source;
    data["iconType"] = this.iconType;
    data["iconUrl"] = this.iconUrl;
    data["url"] = this.url;
    data["alg"] = this.alg;
    return data;
  }
}