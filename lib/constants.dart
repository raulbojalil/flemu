import 'package:flutter/material.dart';

import 'app_config.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const primaryBgColor = Color(0xFF212332);
const secondaryBgColor = Color(0xFF202020);
const errorColor = Color(0xFFF44336);

const searchBoxPadding = 30.0;
const defaultPadding = 30.0;

const mobileMaxWidth = 700;
const desktopMinWidth = 1100;

buildImageUrl(String system, String name) {
  return "${AppConfig.getInstance().apiUrl}/filemanager/image?system=$system&name=$name";
}

buildEmulatorUrl(String core, String filename) {
  return "${AppConfig.getInstance().apiUrl}/emulator?core=$core&filename=$filename";
}

buildEpubReaderUrl(String filename) {
  return "${AppConfig.getInstance().apiUrl}/epubreader?filename=$filename";
}

buildFileHandlerUrl(String core, String filename) {
  return filename.endsWith(".epub")
      ? buildEpubReaderUrl(filename)
      : buildEmulatorUrl(core, filename);
}

buildDownloadUrl(String folder, String filename) {
  return "${AppConfig.getInstance().apiUrl}/filemanager/download?folder=$folder&filename=$filename";
}
