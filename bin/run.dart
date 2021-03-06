import 'dart:async';

import 'package:dslink/dslink.dart';

import 'package:dslink_zoneminder/nodes.dart';

Future main(List<String> args) async {
  LinkProvider link;

  link = new LinkProvider(args, 'ZoneMinder-', command: 'run', profiles: {
        AddSiteNode.isType: (String path) => new AddSiteNode(path, link),
        EditSiteNode.isType: (String path) => new EditSiteNode(path, link),
        RemoveSiteNode.isType: (String path) => new RemoveSiteNode(path, link),
        RestartZm.isType: (String path) => new RestartZm(path),
        SiteNode.isType: (String path) => new SiteNode(path),
        ZmValue.isType: (String path) => new ZmValue(path),
        MonitorNode.isType: (String path) => new MonitorNode(path),
        VideoNode.isType: (String path) => new VideoNode(path),
        RefreshMonitorNode.isType: (String path) => new RefreshMonitorNode(path),
        GetEventsNode.isType: (String path) => new GetEventsNode(path),
        EventNode.isType: (String path) => new EventNode(path),
        DeleteEvent.isType: (String path) => new DeleteEvent(path),
        GetFrames.isType: (String path) => new GetFrames(path),
        FrameNode.isType: (String path) => new FrameNode(path),
        FrameData.isType: (String path) => new FrameData(path),
        RefreshMonitors.isType: (String path) => new RefreshMonitors(path)
      }, defaultNodes: {
      'Sites' : {
        AddSiteNode.pathName: AddSiteNode.definition()
      }
  }, autoInitialize: false, encodePrettyJson: true);

  link.init();
  await link.connect();
}
