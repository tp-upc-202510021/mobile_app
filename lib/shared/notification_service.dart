import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/main.dart'; // para navigatorKey

class NotificationService {
  static void showFromJson(String jsonString) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final data = jsonDecode(jsonString);
    _showToast(context, data);
  }

  static void show({
    required String title,
    required String body,
    bool showButton = false,
    String buttonText = 'Ir',
    VoidCallback? onPressed,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    _showToast(context, {
      'title': title,
      'body': body,
      'show_button': showButton,
      'button_text': buttonText,
      'on_pressed': onPressed,
    });
  }

  static void _showToast(BuildContext context, Map<String, dynamic> data) {
    showFToast(
      context: context,
      alignment: FToastAlignment.topCenter,
      title: Text(data['title'] ?? 'Notificación'),
      description: Text(data['body'] ?? ''),
      suffixBuilder: (data['show_button'] == true)
          ? (ctx, entry, _) => IntrinsicHeight(
              child: FButton(
                style: ctx.theme.buttonStyles.primary.copyWith(
                  contentStyle: ctx.theme.buttonStyles.primary.contentStyle
                      .copyWith(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        textStyle: FWidgetStateMap.all(
                          ctx.theme.typography.xs.copyWith(
                            color: ctx.theme.colors.primaryForeground,
                          ),
                        ),
                      ),
                ),
                onPress: () {
                  entry.dismiss();
                  if (data['on_pressed'] != null) {
                    (data['on_pressed'] as VoidCallback).call();
                  }
                },
                child: Text(data['button_text'] ?? 'Ir'),
              ),
            )
          : null,
    );
  }
}
