import '../../common/player.dart';

abstract class NotificationService {

  void showNotification(Metadata metadata);

  void dispose() {}
}
