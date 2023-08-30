import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;
  final int selected;

  Menu({required this.title, required this.rive, required this.selected});
}

List<Menu> bottomNavItems = [

  Menu(
    title: "Chat",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "CHAT",
        stateMachineName: "CHAT_Interactivity"),
      selected: 0

  ),
  Menu(
    title: "Search",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SEARCH",

        stateMachineName: "SEARCH_Interactivity"),
      selected: 1

  ),


];
