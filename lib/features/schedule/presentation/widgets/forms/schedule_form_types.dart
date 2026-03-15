import 'package:flutter/material.dart';

typedef OnSaveEvent =
    void Function({
      required String type,
      required TimeOfDay start,
      required TimeOfDay end,
      required String color,
      required bool isRecurring,
      required int weeks,
      String? groupId,
      String? clientName,
      String? clientPhone,
      String? coachId,
    });
