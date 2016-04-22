import 'monitor_node.dart';
import 'common.dart';

class VideoNode extends ZmNode {
  static const String liveFeed = 'liveFeed';
  static const String eventFeed = 'eventFeed';
  static const String isType = 'videoNode';

  static const String _feedType = r'$$feedType';
  static Map<String, dynamic> definition(String type) => {
    r'$is': isType,
    _feedType: type,
    r'$name' : 'Video Stream',
    r'$type' : 'binary',
    r'?value' : null,
  };

  VideoNode(String path) : super(path);

  @override
  void onCreated() {
    print('Created video node');
    var client = getClient();

    var strType = getConfig(_feedType);
    (parent as MonitorNode).getMonitor().then((monitor) {
      if (strType == liveFeed) {
        print('Trying to stream video');
        client.getMonitorFeed(monitor).listen((bd) {
          updateValue(bd);
        });
      } else {
        // do it for events too
      }
      });
  }
}