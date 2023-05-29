import 'package:rive/rive.dart';

class RiveUtils {
  static StateMachineController getRiveController(Artboard artboard, {stateMachineName = "State Machine 1"}){
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    return controller;
  }
}