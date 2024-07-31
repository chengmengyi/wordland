// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';

class PlayMusicUtils {
  factory PlayMusicUtils() => _getInstance();

  static PlayMusicUtils get instance => _getInstance();

  static PlayMusicUtils? _instance;

  static PlayMusicUtils _getInstance() {
    _instance ??= PlayMusicUtils._internal();
    return _instance!;
  }

  var playStatus=true;
  // var assAssetsAudioPlayer=AssetsAudioPlayer.newPlayer();

  PlayMusicUtils._internal(){
    playStatus=StorageUtils.read<bool>(StorageName.playStatus)??true;
  }

  updatePlayStatus(){
    playStatus=!playStatus;
    if(playStatus){
      playMusic();
    }else{
      stopMusic();
    }
    StorageUtils.write(StorageName.playStatus, playStatus);
  }

  playMusic()async{
    // assAssetsAudioPlayer.open(
    //   Audio("assets/music.mp3"),
    //   autoStart: true,
    //   showNotification: false,
    //   loopMode: LoopMode.playlist
    // );
  }

  stopMusic(){
    // assAssetsAudioPlayer.stop();
  }
}