import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();
  bool obscure = true;
  final supabase = getIt.get<SupabaseClient>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('My app'),
              gap64,
              CustomTextField(
                controller: emailController,
                label: "Correo",
                required: true,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
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
              CustomButton(
                onTap: onLogin,
                label: "Iniciar sesión",
              ),
              gap32,
              CupertinoButton(
                onPressed: onRegister,
                child: const Text('Registrarse'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onLogin() async {
    if (!mounted) return;
    if (!key.currentState!.validate()) return;
    try {
      context.showPreloader();
      final response = await supabase.auth.signInWithPassword(
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
      );
      if (!mounted) return;
      await context.hidePreloader();
      if (response.session == null) return;
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/splash',
        (route) => false,
      );
    } on Exception catch (e) {
      if (!mounted) return;
      await context.hidePreloader();
      if (!mounted) return;
      context.showErrorSnackBar(message: '$e');
      return;
    }
  }

  void changeObscure() => setState(() {
        obscure = !obscure;
      });

  void onRegister() => Navigator.of(context).pushNamed('/register');
}
