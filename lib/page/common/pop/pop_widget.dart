import 'package:test22/page/common/pop/pop.dart';
import 'package:flutter/material.dart';

// 点击可以弹框的 widget
class PopWidget extends StatefulWidget {
  Widget child;

  PopWidget({Key? key, required this.child}) : super(key: key);

  @override
  _PopWidgetState createState() => _PopWidgetState();
}

class _PopWidgetState extends State<PopWidget> {
  GlobalKey locationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: locationKey,
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => PopPage(
                  locationKey: locationKey,
                ));
      },
      child: widget.child,
    );
  }
}
