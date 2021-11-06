import 'package:event_bus/event_bus.dart';
 
EventBus eventBus = new EventBus();
 
class SearchSongEvent{
  String searchWordNow = '';
  SearchSongEvent(String word) {
    this.searchWordNow = word;
  }
}

class SearchListEvent{
  String searchWordNow = '';
  SearchListEvent(String word) {
    this.searchWordNow = word;
  }
}

class SearchSingerEvent{
  String searchWordNow = '';
  SearchSingerEvent(String word) {
    this.searchWordNow = word;
  }
}