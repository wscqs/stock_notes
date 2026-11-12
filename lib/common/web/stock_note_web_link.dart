/// Parses links that ask the app to open a native stock edit page.
abstract final class StockNoteWebLink {
  /// Returns the requested code, an empty string for a blank edit page, or
  /// null when [uri] is not an app stock-edit link.
  static String? stockEditCode(Uri uri) {
    if (uri.scheme != 'stocknote' || uri.host != 'stocknote.com') {
      return null;
    }
    final route = Uri.parse(uri.fragment);
    if (route.path != '/stockedit') return null;
    return route.queryParameters['code']?.trim() ?? '';
  }
}
