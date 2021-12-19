// import 'package:json_annotation/json_annotation.dart';

// part 'recommend.g.dart';

// @JsonSerializable()
// class recommend extends Object {
//   @JsonKey(name: 'code')
//   int code;

//   @JsonKey(name: 'message')
//   String message;

//   @JsonKey(name: 'ttl')
//   int ttl;

//   @JsonKey(name: 'data')
//   Data data;

//   recommend(
//     this.code,
//     this.message,
//     this.ttl,
//     this.data,
//   );

//   factory recommend.fromJson(Map<String, dynamic> srcJson) =>
//       _$recommendFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$recommendToJson(this);
// }

// @JsonSerializable()
// class Data extends Object {
//   @JsonKey(name: 'items')
//   List<Items> items;

//   @JsonKey(name: 'config')
//   Config config;

//   Data(
//     this.items,
//     this.config,
//   );

//   factory Data.fromJson(Map<String, dynamic> srcJson) =>
//       _$DataFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$DataToJson(this);
// }

// @JsonSerializable()
// class Items extends Object {
//   @JsonKey(name: 'card_type')
//   String cardType;

//   @JsonKey(name: 'card_goto')
//   String cardGoto;

//   @JsonKey(name: 'goto')
//   String goto;

//   @JsonKey(name: 'param')
//   String param;

//   @JsonKey(name: 'cover')
//   String cover;

//   @JsonKey(name: 'title')
//   String title;

//   @JsonKey(name: 'uri')
//   String uri;

//   @JsonKey(name: 'three_point')
//   Three_point threePoint;

//   @JsonKey(name: 'args')
//   Args args;

//   @JsonKey(name: 'player_args')
//   Player_args playerArgs;

//   @JsonKey(name: 'idx')
//   int idx;

//   @JsonKey(name: 'three_point_v2')
//   List<Three_point_v2> threePointV2;

//   @JsonKey(name: 'cover_left_text_1')
//   String coverLeftText1;

//   @JsonKey(name: 'cover_left_icon_1')
//   int coverLeftIcon1;

//   @JsonKey(name: 'cover_left_text_2')
//   String coverLeftText2;

//   @JsonKey(name: 'cover_left_icon_2')
//   int coverLeftIcon2;

//   @JsonKey(name: 'cover_right_text')
//   String coverRightText;

//   @JsonKey(name: 'desc_button')
//   Desc_button descButton;

//   @JsonKey(name: 'official_icon')
//   int officialIcon;

//   @JsonKey(name: 'can_play')
//   int canPlay;

//   Items(
//     this.cardType,
//     this.cardGoto,
//     this.goto,
//     this.param,
//     this.cover,
//     this.title,
//     this.uri,
//     this.threePoint,
//     this.args,
//     this.playerArgs,
//     this.idx,
//     this.threePointV2,
//     this.coverLeftText1,
//     this.coverLeftIcon1,
//     this.coverLeftText2,
//     this.coverLeftIcon2,
//     this.coverRightText,
//     this.descButton,
//     this.officialIcon,
//     this.canPlay,
//   );

//   factory Items.fromJson(Map<String, dynamic> srcJson) =>
//       _$ItemsFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$ItemsToJson(this);
// }

// @JsonSerializable()
// class Three_point extends Object {
//   @JsonKey(name: 'dislike_reasons')
//   List<Dislike_reasons> dislikeReasons;

//   @JsonKey(name: 'feedbacks')
//   List<Feedbacks> feedbacks;

//   @JsonKey(name: 'watch_later')
//   int watchLater;

//   Three_point(
//     this.dislikeReasons,
//     this.feedbacks,
//     this.watchLater,
//   );

//   factory Three_point.fromJson(Map<String, dynamic> srcJson) =>
//       _$Three_pointFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$Three_pointToJson(this);
// }

// @JsonSerializable()
// class Dislike_reasons extends Object {
//   @JsonKey(name: 'id')
//   int id;

//   @JsonKey(name: 'name')
//   String name;

//   @JsonKey(name: 'toast')
//   String toast;

//   Dislike_reasons(
//     this.id,
//     this.name,
//     this.toast,
//   );

//   factory Dislike_reasons.fromJson(Map<String, dynamic> srcJson) =>
//       _$Dislike_reasonsFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$Dislike_reasonsToJson(this);
// }

// @JsonSerializable()
// class Feedbacks extends Object {
//   @JsonKey(name: 'id')
//   int id;

//   @JsonKey(name: 'name')
//   String name;

//   @JsonKey(name: 'toast')
//   String toast;

//   Feedbacks(
//     this.id,
//     this.name,
//     this.toast,
//   );

//   factory Feedbacks.fromJson(Map<String, dynamic> srcJson) =>
//       _$FeedbacksFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$FeedbacksToJson(this);
// }

// @JsonSerializable()
// class Args extends Object {
//   @JsonKey(name: 'up_id')
//   int upId;

//   @JsonKey(name: 'up_name')
//   String upName;

//   @JsonKey(name: 'rid')
//   int rid;

//   @JsonKey(name: 'rname')
//   String rname;

//   @JsonKey(name: 'aid')
//   int aid;

//   Args(
//     this.upId,
//     this.upName,
//     this.rid,
//     this.rname,
//     this.aid,
//   );

//   factory Args.fromJson(Map<String, dynamic> srcJson) =>
//       _$ArgsFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$ArgsToJson(this);
// }

// @JsonSerializable()
// class Player_args extends Object {
//   @JsonKey(name: 'aid')
//   int aid;

//   @JsonKey(name: 'cid')
//   int cid;

//   @JsonKey(name: 'type')
//   String type;

//   @JsonKey(name: 'duration')
//   int duration;

//   Player_args(
//     this.aid,
//     this.cid,
//     this.type,
//     this.duration,
//   );

//   factory Player_args.fromJson(Map<String, dynamic> srcJson) =>
//       _$Player_argsFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$Player_argsToJson(this);
// }

// @JsonSerializable()
// class Three_point_v2 extends Object {
//   @JsonKey(name: 'title')
//   String title;

//   @JsonKey(name: 'type')
//   String type;

//   Three_point_v2(
//     this.title,
//     this.type,
//   );

//   factory Three_point_v2.fromJson(Map<String, dynamic> srcJson) =>
//       _$Three_point_v2FromJson(srcJson);

//   Map<String, dynamic> toJson() => _$Three_point_v2ToJson(this);
// }

// @JsonSerializable()
// class Desc_button extends Object {
//   @JsonKey(name: 'text')
//   String text;

//   @JsonKey(name: 'event')
//   String event;

//   @JsonKey(name: 'type')
//   int type;

//   @JsonKey(name: 'event_v2')
//   String eventV2;

//   Desc_button(
//     this.text,
//     this.event,
//     this.type,
//     this.eventV2,
//   );

//   factory Desc_button.fromJson(Map<String, dynamic> srcJson) =>
//       _$Desc_buttonFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$Desc_buttonToJson(this);
// }

// @JsonSerializable()
// class Config extends Object {
//   @JsonKey(name: 'column')
//   int column;

//   @JsonKey(name: 'autoplay_card')
//   int autoplayCard;

//   @JsonKey(name: 'feed_clean_abtest')
//   int feedCleanAbtest;

//   @JsonKey(name: 'home_transfer_test')
//   int homeTransferTest;

//   @JsonKey(name: 'auto_refresh_time')
//   int autoRefreshTime;

//   @JsonKey(name: 'show_inline_danmaku')
//   int showInlineDanmaku;

//   @JsonKey(name: 'toast')
//   Toast toast;

//   Config(
//     this.column,
//     this.autoplayCard,
//     this.feedCleanAbtest,
//     this.homeTransferTest,
//     this.autoRefreshTime,
//     this.showInlineDanmaku,
//     this.toast,
//   );

//   factory Config.fromJson(Map<String, dynamic> srcJson) =>
//       _$ConfigFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$ConfigToJson(this);
// }

// @JsonSerializable()
// class Toast extends Object {
//   Toast();

//   factory Toast.fromJson(Map<String, dynamic> srcJson) =>
//       _$ToastFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$ToastToJson(this);
// }
