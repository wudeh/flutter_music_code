class Api {
  // 基础 URL
  static String baseUrl = 'https://netease-cloud-music-api-jet.vercel.app/';
  // static String baseUrl = 'http://120.79.155.7/api/';
  // static String baseUrl = 'https://music.qier222.com/api/';

  // 发现首页
  static String homePage = baseUrl + 'homepage/block/page';

  // 首页圆形图标
  static String homePageBall = baseUrl + 'homepage/dragon/ball';

  // 首页默认搜索词
  static String homePageWord = baseUrl + 'search/default';

  // 热搜
  static String searchHotWord = baseUrl + 'search/hot/detail';

  // 获取音乐 URL
  static String songUrl = baseUrl + 'song/url?realIP=116.25.146.177';

  // 获取歌词
  static String songLyric = baseUrl + 'lyric?id=';

  // 搜索建议
  static String searchAd = baseUrl + 'search/suggest?type=mobile&keywords=';

  // 搜索单曲
  static String searchSong = baseUrl + 'cloudsearch';

  // 搜索结果
  static String searchResult = baseUrl + 'search';

  // 歌单信息
  static String songList = baseUrl + 'playlist/detail?id=';

  // 歌曲信息
  static String songDetail = baseUrl + 'song/detail?id=';

  // 评论
  static String comment = baseUrl + 'comment/new?';

  // 热门评论
  static String commentHot = baseUrl + '/comment/hot?';

  // 楼层评论
  static String commentFloor = baseUrl + 'comment/floor?';
}
