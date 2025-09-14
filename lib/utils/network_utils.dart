import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';

Future<T?> safeRequest<T>(
  BuildContext context,
  Future<T> Function() request,
) async {
  try {
    return await request();
  } catch (e) {
    if (e.toString().contains('Sesión expirada')) {
      await context.read<AuthCubit>().logout();
    }
    return null;
  }
}
