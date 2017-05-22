<?php

include_once 'container/indexes.php';
include_once 'container/users.php';
include_once 'container/channels-op.php';

class Container_channels {
  
  static public function getChannelsDir() {
    $datadir = dirname(__FILE__).'/../data';
    $cdir = $datadir.'/channels';
    return $cdir;
  }
  static public function getChannelDir($cid){
    return self::getChannelsDir()."/".$cid;
  }
  static public function getChannels() {

    $dir=self::getChannelsDir();
    $channels = array();
    if (file_exists($dir)) {
      foreach (scandir($dir) as $value) {
        if ($value === '.' || $value === '..') continue;
        $channel=array();
        $channel['id']=$value;
        $channel['ops']=Container_channels_op::getOpList($value);
        for($i=0;$i<count($channel['ops']);$i++){
          $active=Container_channels::checkChannelUser($value,$channel['ops'][$i]);
          $channel['ops'][$i]=array("name"  => Container_users::getUserData($channel['ops'][$i]),"status" => $active);

        }
        $channels[] = $channel;
      }
    }
    return $channels;
  }
  static public function init($cid) {
    $cdir = self::getChannelsDir();
    $cpath = $cdir.'/'.$cid;
    @mkdir($cpath, 0777, true);
    @mkdir($cpath.'/users', 0777, true);
    @mkdir($cpath.'/op', 0777, true);  
    @mkdir($cpath.'/ban', 0777, true);  
  }
  
  static public function generateCid() {
    $cdir = self::getChannelsDir();
    do {
      $cid = sha1(uniqid('', true));
      $cpath = $cdir.'/'.$cid.'/';
    } while (file_exists($cpath));
    self::init($cid);
    return $cid;
  }
  
  static public function getChannelMsgPath($cid, $mid) {
    $cdir = self::getChannelsDir();
    $mpath = $cdir.'/'.$cid.'/msg/'.$mid.'.json';
    return $mpath;
  }
  
  static public function getChannelUserPath($cid, $uid) {
    $cdir = self::getChannelsDir();
    $cupath = $cdir.'/'.$cid.'/users/'.$uid;
    return $cupath;
  }
  
  static public function getChannelUsers($cid, $withudata = false) {
    $cdir = self::getChannelsDir();
    $cupath = $cdir.'/'.$cid.'/users/';  
    $subscribers = array();
    foreach (scandir($cupath) as $uid) {
      if ($uid === '.' || $uid === '..') continue;
      if ($withudata) {
        $subscribers[$uid]       = Container_users::getUserData($uid);
      } else {
        $subscribers[] = $uid;
      }
    }
    return $subscribers;
  }
  
  /**
   * Check if a user is on the given channel
   */
  static public function checkChannelUser($cid, $uid) {
    $cdir = self::getChannelsDir();
    $cupath = $cdir.'/'.$cid.'/users/'.$uid;  
    return file_exists($cupath);
  }  
}

