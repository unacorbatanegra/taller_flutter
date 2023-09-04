import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/widgets.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.onTap,
    required this.isLoading,
  }) : super(key: key);
  final TextEditingController controller;
  final String hint;

  final VoidCallback onTap;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: BorderSide.none,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextFormField(
        // onChanged: onChanged,
        controller: controller,
        onEditingComplete: onTap,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        textCapitalization: TextCapitalization.sentences,
        minLines: 1,
        maxLines: 5,
        maxLength: null,
        onFieldSubmitted: (_) => onTap(),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400
        ),
        decoration: InputDecoration(
          counter: const SizedBox.shrink(),
          enabledBorder: border,
          errorBorder: border,
          disabledBorder: border,
          focusedErrorBorder: border,
          border: border,

          alignLabelWithHint: true,
          focusedBorder: border,
          // contentPadding: const EdgeInsets.symmetric(
          //   horizontal: 16.0,
          //   vertical: 24.0,
          // ), hintText: hint,
          // suffix: suffix,
          isCollapsed: false,

          suffixIcon: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: isLoading ? null : onTap,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  )
                : const Icon(
                    Icons.send,
                    color: Palette.gray1,
                  ),
          ),
          hintText: hint,
          // suffix: suffix,

          hintStyle: const TextStyle(
            color: Palette.gray3,
            fontWeight: FontWeight.w400,
            // fontFamily: 'Lato',
          ),
        ),
      ),
    );
  }
}
