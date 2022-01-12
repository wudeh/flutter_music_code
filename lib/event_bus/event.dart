import 'package:event_bus/event_bus.dart';
 
EventBus eventBus = new EventBus();
 
class SearchSongEvent{
  String searchWordNow = '';
  SearchSongEvent(String word) {
    this.searchWordNow = word;
  }
}

// 用户登录事件
class UserLoggedInEvent {
  // User user;

  UserLoggedInEvent();
}

// 用户退出登录事件
class UserLoggedOutEvent {
  // User user;

  UserLoggedOutEvent();
}