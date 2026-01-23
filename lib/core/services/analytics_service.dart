import 'package:posthog_flutter/posthog_flutter.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  /// Tracks a custom event.
  /// [eventName] is the name of the event.
  /// [properties] is a map of additional data to send with the event.
  Future<void> trackEvent(String eventName, {Map<String, Object>? properties}) async {
    await Posthog().capture(
      eventName: eventName,
      properties: properties,
    );
  }

  /// Identifies the user.
  /// [userId] is the unique identifier for the user.
  /// [userProperties] is a map of user traits.
  Future<void> identifyUser(String userId, {Map<String, Object>? userProperties}) async {
    await Posthog().identify(
      userId: userId,
      userProperties: userProperties,
    );
  }

  /// Resets the user session.
  Future<void> reset() async {
    await Posthog().reset();
  }
}
