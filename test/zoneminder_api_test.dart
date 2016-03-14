import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:dslink_zoneminder/zoneminder_api.dart';
import 'dart:io';
import 'dart:math';

main() {
  group('getMonitors', () {
    var client = new MockClient((Request r) {
      if (r.url.path == '/zm/api/monitors.json') {
        var sampleData = new File('2-monitors.json').readAsStringSync();
        return new Response(sampleData, 200,
            headers: {'content-type': 'application/json'});
      }
    });

    var api = new ZoneMinderApi();
    api.instanceUrl = 'http://localhost:8080';
    api.client = client;

    test('should return correct monitors', () async {
      var result = await api.fetchAllMonitors();

      expect(result.length, 2);
      var monitor1 = result[0];
      expect(monitor1.id, '2');
      expect(monitor1.name, 'Monitor-2');
      expect(monitor1.type, 'Remote');
      expect(monitor1.function, 'Monitor');

      var monitor2 = result[1];
      expect(monitor2.id, '3');
      expect(monitor2.name, 'Monitor-3');
      expect(monitor2.type, 'Local');
      expect(monitor2.function, 'Monitor');
    });
  });

  group('update single monitor', () {
    var api = new ZoneMinderApi();
    api.instanceUrl = 'http://localhost:32769';

    test('fields should be changed after updating it', () async {
      var monitor = (await api.fetchAllMonitors())[0];

      var name = _randomString(10);
      monitor.name = name;

      var sourceType = _randomFromList(Monitor.sourceTypes);
      monitor.type = sourceType;

      var function = _randomFromList(Monitor.functions);
      monitor.function = function;

      await api.updateMonitor(monitor.id, monitor);

      var updatedMonitor = (await api.fetchAllMonitors())[0];
      expect(updatedMonitor.name, name);
      expect(updatedMonitor.type, sourceType);
      expect(updatedMonitor.function, function);
    });
  });
}

const String allowedCharacters =
    '-_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

String _randomString(int length) {
  var random = new Random.secure();
  var allowedCodeUnits = allowedCharacters.codeUnits;

  int max = allowedCodeUnits.length - 1;

  List<int> randomString = [];

  for (int i = 0; i < length; ++i) {
    randomString.add(allowedCodeUnits.elementAt(random.nextInt(max)));
  }

  return new String.fromCharCodes(randomString);
}

String _randomFromList(List<String> choices) {
  var indexToPick = new Random.secure().nextInt(choices.length);

  return choices.elementAt(indexToPick);
}
