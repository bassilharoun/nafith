import 'package:nafith/raqi_app/paytaps/domain/constants.dart';
import 'package:riverpod/riverpod.dart';
import '../presentation/payment/payment_states.dart';
import '../presentation/styles/app_theme.dart';

final themeProvider = StateProvider((ref) => getApplicationLightTheme());

final bottomBarIndexProvider = StateProvider((ref) => 0);

final selectedFilterProvider = StateProvider((ref) => -1);

final eventDetailsShowMoreProvider = StateProvider((ref) => false);

final eventDetailsUpdateNotificationProvider =
    StateProvider.autoDispose((ref) => false);

final eventDetailsUpdatesReadMoreProvider =
    StateProvider.autoDispose((ref) => false);
final selectedEventsIndexProvider = StateProvider((ref) => false);

final selectedPlacesIndexProvider = StateProvider((ref) => false);

final myTicketsFilterProvider = StateProvider((ref) => -1);

final showMoreUpcomingEventsProvider = StateProvider<List<bool>>((ref) => []);

final forYouProvider = StateProvider((ref) => false);

final eventsLoadedProvider = StateProvider<ConnectionStates>((ref) {
  if (!ref.watch(timeoutProvider)) {
    if ((ref.watch(showMoreUpcomingEventsProvider).isNotEmpty &&
        ref.watch(forYouProvider))) {
      return ConnectionStates.connected;
    } else {
      return ConnectionStates.loading;
    }
  } else {
    return ConnectionStates.timeout;
  }
});

final timeoutProvider = StateProvider<bool>((ref) => false);

final timeoutProviderHelper = Provider<void>(
  (ref) => Future.delayed(Duration(seconds: 5)).then(
    (value) {
      if (ref.read(eventsLoadedProvider) == ConnectionStates.loading) {
        ref.read(timeoutProvider.notifier).state = true;
      }
    },
  ),
);


final paymentStateProvider =
    StateProvider<PaymentStates>((ref) => InitialPaymentState());



