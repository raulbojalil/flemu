import 'package:flemu/api/file_manager.dart';
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

buildImageUrl(String systemId, String name) {
  return "${AppConfig.getInstance().apiUrl}/filemanager/image?system=$systemId&name=$name";
}

buildSystemImageUrl(String systemId) {
  return "${AppConfig.getInstance().apiUrl}/filemanager/systemimage?system=$systemId";
}

buildFileHandlerUrl(String handler, String filename, String bios) {
  var separator = !handler.contains("?") ? "?" : "&";
  return "${AppConfig.getInstance().apiUrl}$handler${separator}filename=$filename&bios=$bios";
}

buildDownloadUrl(String systemId, String filename) {
  return "${AppConfig.getInstance().apiUrl}/filemanager/download?system=$systemId&filename=$filename";
}
