class FileNameHandler {
  static String limit(String name, int maxLength) {
    return name.length > maxLength
        ? '${name.substring(0, maxLength)}...'
        : name;
  }
}