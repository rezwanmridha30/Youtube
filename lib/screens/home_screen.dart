

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_youtube_api/models/channel_info.dart';
import 'package:my_youtube_api/models/videos_list.dart';
import 'package:my_youtube_api/screens/video_player_screen.dart';
import 'package:my_youtube_api/utils/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

   late ChannelInfo _channelInfo;
   late ChannelItem  _item;
   late bool _loading;
   late String _playListId;
   late VideosList _videosList;
   late String _nextPageToken;
   late ScrollController _scrollController;



 @override
  void initState() {
    super.initState();
      
    _loading=true;
    _nextPageToken ='';
    _scrollController = ScrollController();
     _videosList = VideosList(etag: '', kind: '', nextPageToken: '',items: [], pageInfo:VideoPageInfo(
        totalResults:0,
        resultsPerPage:1,
    ));
    _videosList.items =[];
    _getChannelInfo();
    
  }

  _getChannelInfo() async{
    _channelInfo = await Services.getChannelInfo();
    _item = _channelInfo.items[0];
    _playListId = _item.contentDetails.relatedPlaylists.uploads;
    print('_playListId $_playListId');
    await _loadVideos();
    setState(() {
      _loading = false;
    });
  }

  _loadVideos() async{
    VideosList tempVideosList = await Services.getVideosList(
      playListId: _playListId,
      pageToken: _nextPageToken,
      );
      _nextPageToken =tempVideosList.nextPageToken;
      _videosList.items.addAll(tempVideosList.items);
      print('videos: ${_videosList.items.length}');
      setState(() {
        
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Youtube"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(
        color:  Colors.white,
        child: Column(
          children: [
            _buildInfoView(),
            Expanded(
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (ScrollNotification notification){
                  if( _videosList.items.length >= int.parse(_item.statistics.videoCount)){
                    return true;
                  }
                  if(notification.metrics.pixels == notification.metrics.maxScrollExtent){
                    _loadVideos();
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _videosList.items.length,
                  itemBuilder: (context, index){
                    Item items = _videosList.items[index];
                    return GestureDetector(
                      onTap: ()async{
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return VideoPlayerScreen(item: items,
                          );
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                          imageUrl: _item.snippet.thumbnails.thumbnailsDefault.url,
                          ),
                          SizedBox(width: 20,),
                          Flexible(child: Text(_item.snippet.title)),
                          SizedBox(width: 20,),
                          ],
                        )
                      
                      ),
                    );
                          
                }),
              ),
            )
          ],
        ),
      ),
      
    );
  }


  _buildInfoView(){
    return _loading
    ?CircularProgressIndicator()
    :Container(
      padding: EdgeInsets.all(10.0),
      child:  Card(
        child:  Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  _item.snippet.thumbnails.medium.url,
                ),
              ),
              SizedBox(width: 20,),
              Expanded(
                child: Text(
                  _item.snippet.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],),
        ),
      ),
    );
  }
}