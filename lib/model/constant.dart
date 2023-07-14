import 'package:flutter/cupertino.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'sport.dart';
class Constant{
  static String appName = 'OLYMPIC';
  static String dbUrl = 'https://olympic-b7cf2-default-rtdb.asia-southeast1.firebasedatabase.app';
  static bool isWeb = false;
  static var colors = const [
    Color(0xff4088d2),
    Color(0xff0d0c0c),
    Color(0xffe3456d),
    Color(0xffd5ad11),
    Color(0xff4cab4b)
  ];

  static var colors2 = const [
    Color(0xff4e85c6),
    Color(0xffbf5271),
    Color(0xff5f9c5f)
  ];

  static var colors3 = const [
    Color(0xff5f9c5f),
    Color(0xffbf5271),
    Color(0xff4e85c6),

  ];
  static var shader = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    // Add one stop for each color. Stops should increase from 0 to 1
    stops: [0.2, 0.4, 0.6, 0.8, 1],
    colors: [
      // Colors are easy thanks to Flutter's Colors class.
      Color(0xff4088d2),
      Color(0xff0d0c0c),
      Color(0xffe3456d),
      Color(0xffd5ad11),
      Color(0xff4cab4b)
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 320.0, 100.0));

  static var sports = [
    'Alpine Skiing',
    'Archery',
    'Archery',
    'Artistic Gymnastics',
    'Artistic Swimming',
    'Athletics',
    'Badminton',
    'Baseball Softball',
    'Basketball',
    'Beach Handball',
    'Beach Volleyball',
    'Biathlon',
    'Bobsleigh',
    'Boxing',
    'Breaking',
    'Canoe Flatwater',
    'Canoe Slalom',
    'Cross-Country Skiing',
    'Curling',
    'Cycling BMX Freestyle',
    'Cycling BMX Freestyle',
    'Cycling BMX Racing',
    'Cycling Mountain Bike',
    'Cycling Road',
    'Cycling Track',
    'Diving',
    'Equestrian',
    'Fencing',
    'Figure Skating',
    'Football',
    'Freestyle Skiing',
    'Freestyle Skiing',
    'Futsal',
    'Golf',
    'Handball',
    'Hockey',
    'Ice Hockey',
    'Jude',
    'Karate',
    'Luge',
    'Marathon Swimming',
    'Modern Pentathlon',
    'Nordic Combined',
    'Rhythmic Gymnastics',
    'Rowing',
    'Rugby Sevens',
    'Sailing',
    'Shooting',
    'Short Track Speed Skating',
    'Skateboarding',
    'Skeleton',
    'Ski Jumping',
    'Ski Mountaineering',
    'Snowboard',
    'Speed Skating',
    'Sport Climbing',
    'Surfing',
    'Swimming',
    'Table Tennis',
    'Taekwondo',
    'Tennis',
    'Trampoline',
    'Triathlon',
    'Volleyball',
    'Water Polo',
    'Weightlifting',
    'Wrestling'
  ];

  static var sampleCategory = [
    'Football',
    'Basketball',
    'Golf',
    'Badminton',
    'Boxing',
  ];

  static List<Sport> sampleSports = [
    Sport(name: 'Football', image: 'fbl.png'),
    Sport(name: 'Basketball', image: 'bkb.png'),
    Sport(name: 'Golf',image: 'glf.png'),
    Sport(name: 'Badminton', image: 'bdm.png'),
    //Sport(name: 'Boxing', image: 'box.png'),
  ];

  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  static String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.max,
    bool webp = true,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';
}