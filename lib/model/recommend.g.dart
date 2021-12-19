// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'recommend.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// recommend _$recommendFromJson(Map<String, dynamic> json) {
//   return recommend(
//     json['code'] as int,
//     json['message'] as String,
//     json['ttl'] as int,
//     Data.fromJson(json['data'] as Map<String, dynamic>),
//   );
// }

// Map<String, dynamic> _$recommendToJson(recommend instance) => <String, dynamic>{
//       'code': instance.code,
//       'message': instance.message,
//       'ttl': instance.ttl,
//       'data': instance.data,
//     };

// Data _$DataFromJson(Map<String, dynamic> json) {
//   return Data(
//     (json['items'] as List<dynamic>)
//         .map((e) => Items.fromJson(e as Map<String, dynamic>))
//         .toList(),
//     Config.fromJson(json['config'] as Map<String, dynamic>),
//   );
// }

// Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
//       'items': instance.items,
//       'config': instance.config,
//     };

// Items _$ItemsFromJson(Map<String, dynamic> json) {
//   return Items(
//     json['card_type'] as String,
//     json['card_goto'] as String,
//     json['goto'] as String,
//     json['param'] as String,
//     json['cover'] as String,
//     json['title'] as String,
//     json['uri'] as String,
//     Three_point.fromJson(json['three_point'] as Map<String, dynamic>),
//     Args.fromJson(json['args'] as Map<String, dynamic>),
//     Player_args.fromJson(json['player_args'] as Map<String, dynamic>),
//     json['idx'] as int,
//     (json['three_point_v2'] as List<dynamic>)
//         .map((e) => Three_point_v2.fromJson(e as Map<String, dynamic>))
//         .toList(),
//     json['cover_left_text_1'] as String,
//     json['cover_left_icon_1'] as int,
//     json['cover_left_text_2'] as String,
//     json['cover_left_icon_2'] as int,
//     json['cover_right_text'] as String,
//     Desc_button.fromJson(json['desc_button'] as Map<String, dynamic>),
//     json['official_icon'] as int,
//     json['can_play'] as int,
//   );
// }

// Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
//       'card_type': instance.cardType,
//       'card_goto': instance.cardGoto,
//       'goto': instance.goto,
//       'param': instance.param,
//       'cover': instance.cover,
//       'title': instance.title,
//       'uri': instance.uri,
//       'three_point': instance.threePoint,
//       'args': instance.args,
//       'player_args': instance.playerArgs,
//       'idx': instance.idx,
//       'three_point_v2': instance.threePointV2,
//       'cover_left_text_1': instance.coverLeftText1,
//       'cover_left_icon_1': instance.coverLeftIcon1,
//       'cover_left_text_2': instance.coverLeftText2,
//       'cover_left_icon_2': instance.coverLeftIcon2,
//       'cover_right_text': instance.coverRightText,
//       'desc_button': instance.descButton,
//       'official_icon': instance.officialIcon,
//       'can_play': instance.canPlay,
//     };

// Three_point _$Three_pointFromJson(Map<String, dynamic> json) {
//   return Three_point(
//     (json['dislike_reasons'] as List<dynamic>)
//         .map((e) => Dislike_reasons.fromJson(e as Map<String, dynamic>))
//         .toList(),
//     (json['feedbacks'] as List<dynamic>)
//         .map((e) => Feedbacks.fromJson(e as Map<String, dynamic>))
//         .toList(),
//     json['watch_later'] as int,
//   );
// }

// Map<String, dynamic> _$Three_pointToJson(Three_point instance) =>
//     <String, dynamic>{
//       'dislike_reasons': instance.dislikeReasons,
//       'feedbacks': instance.feedbacks,
//       'watch_later': instance.watchLater,
//     };

// Dislike_reasons _$Dislike_reasonsFromJson(Map<String, dynamic> json) {
//   return Dislike_reasons(
//     json['id'] as int,
//     json['name'] as String,
//     json['toast'] as String,
//   );
// }

// Map<String, dynamic> _$Dislike_reasonsToJson(Dislike_reasons instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'toast': instance.toast,
//     };

// Feedbacks _$FeedbacksFromJson(Map<String, dynamic> json) {
//   return Feedbacks(
//     json['id'] as int,
//     json['name'] as String,
//     json['toast'] as String,
//   );
// }

// Map<String, dynamic> _$FeedbacksToJson(Feedbacks instance) => <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'toast': instance.toast,
//     };

// Args _$ArgsFromJson(Map<String, dynamic> json) {
//   return Args(
//     json['up_id'] as int,
//     json['up_name'] as String,
//     json['rid'] as int,
//     json['rname'] as String,
//     json['aid'] as int,
//   );
// }

// Map<String, dynamic> _$ArgsToJson(Args instance) => <String, dynamic>{
//       'up_id': instance.upId,
//       'up_name': instance.upName,
//       'rid': instance.rid,
//       'rname': instance.rname,
//       'aid': instance.aid,
//     };

// Player_args _$Player_argsFromJson(Map<String, dynamic> json) {
//   return Player_args(
//     json['aid'] as int,
//     json['cid'] as int,
//     json['type'] as String,
//     json['duration'] as int,
//   );
// }

// Map<String, dynamic> _$Player_argsToJson(Player_args instance) =>
//     <String, dynamic>{
//       'aid': instance.aid,
//       'cid': instance.cid,
//       'type': instance.type,
//       'duration': instance.duration,
//     };

// Three_point_v2 _$Three_point_v2FromJson(Map<String, dynamic> json) {
//   return Three_point_v2(
//     json['title'] as String,
//     json['type'] as String,
//   );
// }

// Map<String, dynamic> _$Three_point_v2ToJson(Three_point_v2 instance) =>
//     <String, dynamic>{
//       'title': instance.title,
//       'type': instance.type,
//     };

// Desc_button _$Desc_buttonFromJson(Map<String, dynamic> json) {
//   return Desc_button(
//     json['text'] as String,
//     json['event'] as String,
//     json['type'] as int,
//     json['event_v2'] as String,
//   );
// }

// Map<String, dynamic> _$Desc_buttonToJson(Desc_button instance) =>
//     <String, dynamic>{
//       'text': instance.text,
//       'event': instance.event,
//       'type': instance.type,
//       'event_v2': instance.eventV2,
//     };

// Config _$ConfigFromJson(Map<String, dynamic> json) {
//   return Config(
//     json['column'] as int,
//     json['autoplay_card'] as int,
//     json['feed_clean_abtest'] as int,
//     json['home_transfer_test'] as int,
//     json['auto_refresh_time'] as int,
//     json['show_inline_danmaku'] as int,
//     Toast.fromJson(json['toast'] as Map<String, dynamic>),
//   );
// }

// Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
//       'column': instance.column,
//       'autoplay_card': instance.autoplayCard,
//       'feed_clean_abtest': instance.feedCleanAbtest,
//       'home_transfer_test': instance.homeTransferTest,
//       'auto_refresh_time': instance.autoRefreshTime,
//       'show_inline_danmaku': instance.showInlineDanmaku,
//       'toast': instance.toast,
//     };

// Toast _$ToastFromJson(Map<String, dynamic> json) {
//   return Toast();
// }

// Map<String, dynamic> _$ToastToJson(Toast instance) => <String, dynamic>{};
