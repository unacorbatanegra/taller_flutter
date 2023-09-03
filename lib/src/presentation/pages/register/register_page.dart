import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();
  bool obscure = true;
  final supabase = getIt.get<SupabaseClient>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarme'),
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            bottom: 64,
          ),
          child: CustomButton(
            onTap: onRegister,
            label: "Registrarme",
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // const Text('Registrarse'),
              // gap64,
              CustomTextField(
                controller: emailController,
                label: "Correo",
                required: true,
                autofocus: true,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                hint: 'ingrese su correo',
              ),
              CustomTextField(
                controller: passwordController,
                label: "Contraseña",
                obscureText: obscure,
                // validator: ,
                required: true,
                // onTap: changeObscure,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.visiblePassword,
                suffix: IconButton.filled(
                  onPressed: changeObscure,
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                hint: 'ingrese su contraseña',
              ),
              gap32,
            ],
          ),
        ),
      ),
    );
  }

  void onRegister() async {
    if (!key.currentState!.validate()) return;
    try {
      context.showPreloader();
      final r = await supabase.auth.signUp(
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
      );
      log.d(r.session);
      log.d(r.user);
    } on Exception catch (e) {
      await context.hidePreloader();
      if (!mounted) return;
      context.showErrorSnackBar(message: e.toString());
      return;
    }
    if (!mounted) return;
    await context.hidePreloader();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/splash', (route) => false);
  }

  void changeObscure() => setState(() {
        obscure = !obscure;
      });
}
