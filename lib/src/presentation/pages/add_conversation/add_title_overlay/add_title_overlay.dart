import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/widgets.dart';

class AddTitleOverlay extends StatefulWidget {
  const AddTitleOverlay({super.key});

  @override
  State<AddTitleOverlay> createState() => _AddTitleOverlayState();
}

class _AddTitleOverlayState extends State<AddTitleOverlay> {
  final key = GlobalKey<FormState>();
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        color: Palette.background,
        borderRadius: const BorderRadius.only(
          topLeft: radius8,
          topRight: radius8,
        ),
        child: Container(
          width: context.w,
          constraints: BoxConstraints(
            minHeight: context.h * .2,
            maxHeight: context.h * .5,
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Palette.background,
            borderRadius: BorderRadius.only(
              topLeft: radius8,
              topRight: radius8,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CupertinoButton(
                        onPressed: onBack,
                        child: const Icon(Icons.close),
                      ),
                      Expanded(
                        child: Text(
                          'Titulo',
                          textAlign: TextAlign.start,
                          style: context.h6,
                        ),
                      ),
                      CupertinoButton(
                        onPressed: onSave,
                        child: const Icon(Icons.done),
                      ),
                    ],
                  ),
                  CustomTextField(
                    controller: controller,
                    label: 'Nombre de la conversación',
                    autofocus: true,
                    hint: 'ingrese el nombre para su conversación',
                  ).paddingSymmetric(horizontal: 16.0),
                  gap48,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBack() => Navigator.of(context).pop();

  void onSave() {
    if (!key.currentState!.validate()) return;
    Navigator.of(context).pop(controller.text.trim());
  }
}
