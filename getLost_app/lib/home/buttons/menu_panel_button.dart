import 'package:flutter/material.dart';

class MenuPanelButton extends StatelessWidget {
  final VoidCallback _onPressed;

  MenuPanelButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size(44, 44),
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          primary: Color(0xffFBF9F8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xffE9E7E3), width: 0.5),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(12)),
          ),
        ),
        onPressed: _onPressed,
        child: Icon(
          Icons.more_vert,
          color: Color(0xff9F9F9F),
          size: 26,
        ),
      ),
    );
  }
}
