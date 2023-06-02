import 'package:rive/rive.dart';

class RiveUtils {
  static RiveAnimationController getRiveController(Artboard artboard,
  {statemachineName = 'State Machine 1'}) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      statemachineName,
    );
    artboard.addController(controller!);
    return controller;
  }
}