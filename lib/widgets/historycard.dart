import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:async';

import '../globals.dart';

class HistoryCard extends StatefulWidget {
  final List<String> history;
  final String provider;

  const HistoryCard({
    super.key,
    required this.history,
    required this.provider,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  Map<String, String> tittles = {};
  Future<String> getTitle(String url) async {
    if (tittles.containsKey(url)) {
      return tittles[url]!;
    }
    String title = '';
    try {
      if (await canLaunchUrlString(url)) {
        final response = await http.get(Uri.parse(url));
        final document = parse(utf8.decode(response.bodyBytes));
        title = document.querySelector('title')!.text;
        tittles[url] = title;
      }
    } catch (e) {
      debugPrint('Error getting title: $e');
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      //color: Platform.isLinux ? AdwaitaColors.light3 : null,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: widget.history.isNotEmpty
              ? const Radius.circular(10)
              : Radius.zero,
          bottomRight: widget.history.isNotEmpty
              ? const Radius.circular(10)
              : Radius.zero,
        ),
      ),
      child: Column(
        children: [
          ListView.builder(
            itemCount: widget.history.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                key: ValueKey(widget.history[index]),
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: index == widget.history.length - 1
                        ? const Radius.circular(10)
                        : Radius.zero,
                    bottomRight: index == widget.history.length - 1
                        ? const Radius.circular(10)
                        : Radius.zero,
                  ),
                ),
                title: FutureBuilder(
                  future: getTitle(widget.history[index]),
                  builder: (context, snapshot) {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return Text(
                        // Title settings
                        snapshot.data.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return Text(
                        // Title settings
                        widget.history[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                  },
                ),
                onTap: () {
                  UrlLauncherFunctions.launchURL(
                    context,
                    history[index],
                    provider,
                  );
                },
                trailing: Platform.isLinux
                    ? IconButton(
                        onPressed: () {},
                        icon: const AdwaitaIcon(AdwaitaIcons.copy),
                      )
                    : IconButton(
                        onPressed: () {
                          Share.share(
                              '${widget.provider}${widget.history[index]}');
                        },
                        icon: const Icon(Icons.share),
                      ),
                leading: IconButton(
                  icon: Platform.isLinux
                      ? const AdwaitaIcon(AdwaitaIcons.edit_delete)
                      : const Icon(Icons.delete_forever_outlined),
                  onPressed: () {
                    HistoryFunctions.removeHistorico(index);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
