import 'package:flutter/material.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveFeature extends StatefulWidget {
  final Widget webScreenDesign;
  final Widget mobileScreenDesign;

  const ResponsiveFeature(
      {Key key, this.webScreenDesign, this.mobileScreenDesign})
      : super(key: key);

  @override
  _ResponsiveFeatureState createState() => _ResponsiveFeatureState();
}

class _ResponsiveFeatureState extends State<ResponsiveFeature> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > otherScreenSize) {
        return widget.webScreenDesign;
      }
      return widget.mobileScreenDesign;
    });
  }
}
