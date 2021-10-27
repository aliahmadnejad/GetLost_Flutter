import 'package:flutter/material.dart';

class HostelListButton extends StatelessWidget {
  final VoidCallback _onPressed;

  HostelListButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      padding: EdgeInsets.all(0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size(44, 44),
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          primary: Color(0xffFBF9F8),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xffE9E7E3),
              width: 0.5,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(0)),
          ),
        ),
        onPressed: _onPressed,
        child: Container(
          // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Icon(
            Icons.list_rounded,
            color: Color(0xff9F9F9F),
            size: 28,
          ),
        ),
      ),
    );
  }
}
