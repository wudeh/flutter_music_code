class Api {
  // 基础 URL
  static String baseUrl = 'https://n.xlz122.cn/api/';
  // static String baseUrl = 'https://netease-cloud-music-api-jet.vercel.app/'; 这是自己的
  // static String baseUrl = 'http://120.79.155.7/api/';
  // static String baseUrl = 'https://music.qier222.com/api/';

  static const String API_KEY = "6f168a946f5455fc625b7f192bc45a22";
  static const String APP_KEY = "e2f5e85d67d48530d5088431205f71ca";

  // 查看版本信息 看看是否需要更新
  static String checkVersion = "https://www.pgyer.com/apiv2/app/check";

  // 查看线上安装包大小
  static String appSize = "https://www.pgyer.com/apiv2/app/view";

  // 下载更新安装包
  static String install = "https://www.pgyer.com/apiv2/app/install";

  // 发现首页
  static String homePage = baseUrl + 'homepage/block/page?refresh=true';

  // 首页圆形图标
  static String homePageBall = baseUrl + 'homepage/dragon/ball';

  // 首页默认搜索词
  static String homePageWord = baseUrl + 'search/default';

  // 热搜
  static String searchHotWord = baseUrl + 'search/hot/detail';

  // 获取音乐 URL
  static String songUrl = baseUrl + 'song/url?realIP=116.25.146.177';

  // 获取下载用的无损音质 URL
  static String downloadUrl = baseUrl + 'song/download/url?realIP=116.25.146.177';

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

  // 发送验证码
  static String captchaSent = baseUrl + 'captcha/sent?phone=';

  // 验证码 手机号 登录
  static String login = baseUrl + 'login/cellphone?';

  // 退出登录
  static String logout = baseUrl + 'logout';

  // 上传头像 /avatar/upload
  static String avatarUpload = baseUrl + 'avatar/upload';

  // 获取用户歌单
  static String getUserPlaylist = baseUrl + 'user/playlist?uid=';

  // 获取用户私信 msg/private
  static String privateMsg = baseUrl + 'msg/private';
}
