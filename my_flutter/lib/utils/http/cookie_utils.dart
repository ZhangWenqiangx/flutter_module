import 'dart:io';

class CookieUtils {
  static List<Cookie> encodeCookie(String? cookieStr) {
    var resultCookies = <Cookie>[];
    var cookieArr = cookieStr?.split(";");
    cookieArr?.forEach((cookies) {
      var arr = cookies.split("=");
      if (arr[0].trim() != "Expires") {
        var cookie = new Cookie(arr[0].trim(), arr[1].trim());
        resultCookies.add(cookie);
      }
    });
    return resultCookies;
  }
}
