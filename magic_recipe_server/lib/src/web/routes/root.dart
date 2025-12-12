import 'package:magic_recipe_server/src/web/widgets/flutter_web_page.dart';
import 'package:serverpod/serverpod.dart';

class RootRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return FlutterWebPage();
  }
}
