import 'dart:io';

Future<void> main() async {
  const List<List<String>> commands = [
    // ['flutter', 'clean'],
    // ['flutter', 'pub', 'get'],
    // ['dart', 'analyze'],
    // ['flutter', 'pub', 'run', 'flutter_launcher_icons'],
    // ['flutter', 'build', 'apk', '--release', '--obfuscate', '--split-debug-info=./build/symbols/apk'],
    // ['flutter', 'build', 'appbundle', '--release', '--obfuscate', '--split-debug-info=./build/symbols/appbundle'],
  ];

  for (var command in commands) {
    await runCommand(command);
  }

  const String outputPath = 'build/output';

  final Directory outputDir = Directory(outputPath);
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }
  for (var file in outputDir.listSync()) {
    await file.delete();
  }

  const Map<String, String> pathFinaly = {
    'build/app/outputs/flutter-apk/app-release.apk': 'app-release',
    'build/app/outputs/bundle/release/app-release.aab': 'appbundle-release',
    'build/symbols/apk/*': 'apk-symbols',
    'build/symbols/appbundle/*': 'appbundle-symbols',
    // 'build/app/intermediates/merged_native_libs/release/out/lib': 'native-symbols',
    'build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/*': 'native-symbols',
  };

  for (var i = 0; i < pathFinaly.length; i++) {
    await zipFiles(
      pathFinaly.keys.toList()[i],
      pathFinaly.values.toList()[i],
      outputPath,
    );
  }
}

Future<void> runCommand(List<String> command) async {
  try {
    stderr.write('Running: ${command.join(' ')}');
    final process = await Process.start(
      command.first,
      command.sublist(1),
      runInShell: true,
    );

    process.stdout.listen((data) {
      stderr.add(data);
    });

    process.stderr.listen((data) {
      stderr.add(data);
    });

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      stderr.write('Command failed with exit code $exitCode\n');
    } else {
      stderr.write('Command completed successfully.\n');
    }
  } catch (e) {
    stderr.write('Error executing command: $e\n');
  }
}

Future<void> zipFiles(
    String inputPath, String outputFile, String outputPath) async {
  final zipPath = '$outputPath/$outputFile.zip';

  try {
    final command = [
      'powershell',
      '-Command',
      'Compress-Archive',
      '-Path',
      inputPath,
      '-DestinationPath',
      zipPath,
      '-CompressionLevel',
      'NoCompression'
    ];

    final process = await Process.start(
      command.first,
      command.sublist(1),
      runInShell: true,
    );

    process.stdout.listen((data) {
      stderr.add(data);
    });

    process.stderr.listen((data) {
      stderr.add(data);
    });

    final exitCode = await process.exitCode;
    if (exitCode == 0) {
      stderr.write('Path successfully zipped: $zipPath\n');
    } else {
      stderr.write('Failed to zip Path with exit code $exitCode\n');
    }
  } catch (e) {
    stderr.write('Error while zipping Path: $e\n');
  }
}

/*

git remote -v

git remote set-url origin https://github.com/

git remote -v

git push origin main

*/
