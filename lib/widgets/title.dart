import 'package:flutter/material.dart';

class Titles extends StatelessWidget {
  final String value;
  final bool impReq;
  const Titles(this.value, this.impReq, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Row(
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          impReq
              ? const Text(
                  " *",
                  style: TextStyle(color: Colors.red),
                )
              : Container()
        ],
      ),
    );
  }
}
