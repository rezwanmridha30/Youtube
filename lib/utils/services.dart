import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_youtube_api/models/channel_info.dart';
import 'package:my_youtube_api/models/videos_list.dart';

import 'constants.dart';

class Services{
  static const CHANNEL_ID='UC5lbdURzjB0irr-FTbjWN1A';
  static const _baseUrl = 'youtube.googleapis.com';
  /*'https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=UC5lbdURzjB0irr-FTbjWN1A&pageToken=AIzaSyCac4JAOtHzz1jkWPsfDr-YjqGVPdXOaYA&key=[YOUR_API_KEY]' \
  --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
  --header 'Accept: application/json' \
  --compressed

*/


/*'https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=UU5lbdURzjB0irr-FTbjWN1A&access_token=AIzaSyCac4JAOtHzz1jkWPsfDr-YjqGVPdXOaYA&key=[YOUR_API_KEY]' \
  --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
  --header 'Accept: application/json' \
  --compressed */
  static Future <ChannelInfo> getChannelInfo()async{
    Map<String, String> parameters = {
      'part':'snippet,contentDetails,statistics',
      'id': CHANNEL_ID,
      'key': Constants.API_KEY,
  };
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  
  //Uri uri = Uri.https(a);
  Uri uri = Uri.https(_baseUrl, '/youtube/v3/channels',parameters,);
  Response response =await http.get(uri, headers: headers);
  print(response.body);
  ChannelInfo channelInfo = channelInfoFromJson(response.body);
  return channelInfo;
  }

  static Future<VideosList> getVideosList({required String playListId, required String pageToken,/* String _playListId*/})async{
     Map<String, String> parameters ={
       'part':'snippet',
       'playListId':playListId,
       'maxResults':'8',
       'access_token': Constants.API_KEY,
       'key':Constants.API_KEY,
       };
       Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
         var uri = Uri.parse("https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playListId&access_token=AIzaSyCac4JAOtHzz1jkWPsfDr-YjqGVPdXOaYA&key=AIzaSyCac4JAOtHzz1jkWPsfDr-YjqGVPdXOaYA");
  Response response =await http.get(uri, headers: headers);
  print(response.body);
  VideosList videosList = videosListFromJson(response.body);
  return videosList;
  }
}