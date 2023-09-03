import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final key = GlobalKey<FormState>();
  bool obscure = true;
  final supabase = getIt.get<SupabaseClient>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completar perfil')),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            bottom: 64,
          ),
          child: CustomButton(
            onTap: onComplete,
            label: "Guardar cambios",
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: key,
          child: Column(
            // s
            children: [
              CustomTextField(
                controller: firstNameController,
                label: "Nombre",
                required: true,
                autofocus: true,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                hint: 'ingrese su nombre',
              ),
              CustomTextField(
                controller: lastNameController,
                label: "Apellido",

                // validator: ,
                required: true,
                // onTap: changeObscure,
                textCapitalization: TextCapitalization.none,

                hint: 'ingrese su apellido',
              ),
              gap32,
            ],
          ),
        ),
      ),
    );
  }

  void onComplete() async {
    if (!key.currentState!.validate()) return;

    try {
      context.showPreloader();
      final data = {
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
      };
      await supabase.from('profiles').update(data).eq(
            'id',
            supabase.auth.currentUser?.id,
          );
      await supabase.auth.updateUser(
        UserAttributes(
          data: {'profile_completed': true},
        ),
      );
      if (!mounted) return;
      await context.hidePreloader();
    } on Exception catch (e) {
      await context.hidePreloader();
      if (!mounted) return;
      context.showErrorSnackBar(message: e.toString());
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/splash', (route) => false);
  }
}
