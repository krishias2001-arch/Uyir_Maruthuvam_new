import 'package:flutter/material.dart';
import 'package:uyir_maruthuvam_new/core/widgets/patient_upcoming_schedule.dart';

import 'package:uyir_maruthuvam_new/l10n/app_localizations.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;

  final _scheduleWidgets = [const PatientUpcomingSchdule(), Container(), Container()];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                l10n.schedule,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTabButton(0, l10n.upcoming),
                  _buildTabButton(1, l10n.completed),
                  _buildTabButton(2, l10n.cancelled),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _scheduleWidgets[_buttonIndex],
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          _buttonIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: _buttonIndex == index ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _buttonIndex == index ? Colors.white : Colors.black38,
          ),
        ),
      ),
    );
  }
}
