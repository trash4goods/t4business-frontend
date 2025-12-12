import 'package:flutter/material.dart';

class SettingsItemModel {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDestructive;

  const SettingsItemModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.isDestructive = false,
  });
}