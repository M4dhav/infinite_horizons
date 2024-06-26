import 'package:flutter/material.dart';
import 'package:infinite_horizons/domain/player_controller.dart';
import 'package:infinite_horizons/domain/vibration_controller.dart';
import 'package:infinite_horizons/presentation/atoms/atoms.dart';
import 'package:infinite_horizons/presentation/molecules/molecules.dart';
import 'package:infinite_horizons/presentation/organisms/organisms.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeState state = HomeState.getReadyForStudy;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void onTimerComplete() {
    HomeState nextState;
    switch (state) {
      case HomeState.study:
        nextState = HomeState.getReadyForBreak;
      case HomeState.getReadyForBreak:
        nextState = HomeState.breakTime;
      case HomeState.breakTime:
        nextState = HomeState.getReadyForStudy;
      case HomeState.getReadyForStudy:
        nextState = HomeState.study;
    }

    setState(() {
      state = nextState;
    });
  }

  Widget stateWidget() {
    switch (state) {
      case HomeState.study:
        PlayerController.instance.play('start_session.wav');
        VibrationController.instance.vibrate(VibrationType.heavy);
        return TimerOrganism(TimerVariant.study, onComplete: onTimerComplete);
      case HomeState.getReadyForBreak:
        PlayerController.instance.play('session_completed.wav');
        VibrationController.instance.vibrate(VibrationType.medium);
        return ProgressIndicatorMolecule(
          ProgressIndicatorVariant.beforeBreak,
          onComplete: onTimerComplete,
        );
      case HomeState.breakTime:
        return TimerOrganism(
          TimerVariant.breakTime,
          onComplete: onTimerComplete,
        );
      case HomeState.getReadyForStudy:
        return ProgressIndicatorMolecule(
          ProgressIndicatorVariant.beforeStudy,
          onComplete: onTimerComplete,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MarginedExpandedAtom(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TopBarMolecule(
              title: 'study_efficiency',
              topBarType: TopBarType.none,
            ),
            const SeparatorAtom(variant: SeparatorVariant.farApart),
            Expanded(
              child: stateWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

enum HomeState {
  study,
  getReadyForBreak,
  breakTime,
  getReadyForStudy,
  ;
}
