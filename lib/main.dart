import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'data/mock_customer_data.dart';
import 'design_system/theme.dart';
import 'navigation/app_routes.dart';
import 'screens/auth/account_details_screen.dart';
import 'screens/auth/location_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/verify_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/customer/about_screen.dart';
import 'screens/customer/addresses_screen.dart';
import 'screens/customer/appearance_screen.dart';
import 'screens/customer/customer_shell.dart';
import 'screens/customer/garment_catalogue_screen.dart';
import 'screens/customer/info_detail_screen.dart';
import 'screens/customer/live_tracking_screen.dart';
import 'screens/customer/notifications_screen.dart';
import 'screens/customer/offers_screen.dart';
import 'screens/customer/order_confirmed_screen.dart';
import 'screens/customer/order_detail_screen.dart';
import 'screens/customer/order_history_screen.dart';
import 'screens/customer/partner_catalogue_screen.dart';
import 'screens/customer/partner_detail_screen.dart';
import 'screens/customer/partner_discovery_screen.dart';
import 'screens/customer/payment_methods_screen.dart';
import 'screens/customer/payment_screen.dart';
import 'screens/customer/saved_items_screen.dart';
import 'screens/customer/schedule_pickup_screen.dart';
import 'screens/customer/search_screen.dart';
import 'screens/customer/services_screen.dart';
import 'screens/customer/settings_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_shell.dart';
import 'screens/driver/driver_shell.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/partner/partner_shell.dart';
import 'screens/splash_screen.dart';
import 'state/addresses_controller.dart';
import 'state/admin_controller.dart';
import 'state/cart_controller.dart';
import 'state/favorites_controller.dart';
import 'state/location_controller.dart';
import 'state/driver_controller.dart';
import 'state/locale_controller.dart';
import 'state/orders_controller.dart';
import 'state/partner_controller.dart';
import 'state/theme_controller.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const LaundryGoFlowApp());
}

class LaundryGoFlowApp extends StatefulWidget {
  const LaundryGoFlowApp({super.key});

  @override
  State<LaundryGoFlowApp> createState() => _LaundryGoFlowAppState();
}

class _LaundryGoFlowAppState extends State<LaundryGoFlowApp> {
  final ThemeController _themeController = ThemeController()..load();
  final LocaleController _localeController = LocaleController()..load();
  final CartController _cartController = CartController();
  final AddressesController _addressesController = AddressesController();
  final FavoritesController _favoritesController = FavoritesController();
  final LocationController _locationController = LocationController();
  final OrdersController _ordersController = OrdersController();
  final PartnerController _partnerController = PartnerController();
  final DriverController _driverController = DriverController();
  final AdminController _adminController = AdminController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>.value(value: _themeController),
        ChangeNotifierProvider<LocaleController>.value(
          value: _localeController,
        ),
        ChangeNotifierProvider<CartController>.value(value: _cartController),
        ChangeNotifierProvider<AddressesController>.value(
          value: _addressesController,
        ),
        ChangeNotifierProvider<FavoritesController>.value(
          value: _favoritesController,
        ),
        ChangeNotifierProvider<LocationController>.value(
          value: _locationController,
        ),
        ChangeNotifierProvider<OrdersController>.value(
          value: _ordersController,
        ),
        ChangeNotifierProvider<PartnerController>.value(
          value: _partnerController,
        ),
        ChangeNotifierProvider<DriverController>.value(
          value: _driverController,
        ),
        ChangeNotifierProvider<AdminController>.value(
          value: _adminController,
        ),
      ],
      child: Consumer2<ThemeController, LocaleController>(
        builder: (context, themeController, localeController, _) =>
            MaterialApp(
          title: 'LaundryGo',
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: LGTheme.light,
          darkTheme: LGTheme.dark,
          themeMode: themeController.mode,
          locale: localeController.locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (_) => const SplashScreen(),
            AppRoutes.onboarding: (_) => const OnboardingScreen(),
            AppRoutes.login: (_) => const LoginScreen(),
            AppRoutes.verify: (_) => const VerifyScreen(),
            AppRoutes.accountDetails: (_) => const AccountDetailsScreen(),
            AppRoutes.welcome: (_) => const WelcomeScreen(),
            AppRoutes.location: (_) => const LocationScreen(),
            AppRoutes.customerHome: (_) => const CustomerShell(),
            AppRoutes.services: (_) => const ServicesScreen(),
            AppRoutes.partnerDiscovery: (_) => const PartnerDiscoveryScreen(),
            AppRoutes.liveTracking: (_) => const LiveTrackingScreen(),
            AppRoutes.orderDetail: (_) => const OrderDetailScreen(),
            AppRoutes.payment: (_) => const PaymentScreen(),
            AppRoutes.orderConfirmed: (_) => const OrderConfirmedScreen(),
            AppRoutes.addresses: (_) => const AddressesScreen(),
            AppRoutes.paymentMethods: (_) => const PaymentMethodsScreen(),
            AppRoutes.offers: (_) => const OffersScreen(),
            AppRoutes.orderHistory: (_) => const OrderHistoryScreen(),
            AppRoutes.savedItems: (_) => const SavedItemsScreen(),
            AppRoutes.helpCenter: (_) => const InfoDetailScreen(
              eyebrow: 'SUPPORT',
              title: 'Help ',
              accent: 'Center',
              paragraphs: [
                'Find quick answers to the most common questions about pickups, delivery windows, pricing and payments.',
                'Can\'t find what you need? Reach us directly below and our team will get back to you within a few hours.',
              ],
              contactRows: [],
            ),
            AppRoutes.contactUs: (_) => InfoDetailScreen(
              eyebrow: 'SUPPORT',
              title: 'Contact ',
              accent: 'Us',
              paragraphs: const [
                'Our team is available every day, 8 AM to 10 PM, across Muscat and the surrounding governorates.',
              ],
              contactRows: [
                ContactRow(
                  icon: Icons.call_outlined,
                  label: '+968 2444 5566',
                  onTap: () => scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Calling +968 2444 5566...')),
                  ),
                ),
                ContactRow(
                  icon: Icons.email_outlined,
                  label: 'support@laundrygo.om',
                  onTap: () => scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(
                      content: Text('Opening mail to support@laundrygo.om...'),
                    ),
                  ),
                ),
                ContactRow(
                  icon: Icons.chat_outlined,
                  label: 'Live chat',
                  onTap: () => scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(
                      content: Text('Connecting you to live chat...'),
                    ),
                  ),
                ),
              ],
            ),
            AppRoutes.privacyPolicy: (_) => const InfoDetailScreen(
              eyebrow: 'LEGAL',
              title: 'Privacy ',
              accent: 'Policy',
              paragraphs: [
                'We collect only the information needed to schedule pickups, process payments and deliver your order — your name, address, phone number and order history.',
                'We never sell your personal data. Location data is used solely to match you with nearby partners and track live deliveries.',
                'You can request a copy or deletion of your data at any time from Contact Us.',
              ],
            ),
            AppRoutes.terms: (_) => const InfoDetailScreen(
              eyebrow: 'LEGAL',
              title: 'Terms & ',
              accent: 'Conditions',
              paragraphs: [
                'By booking a pickup you agree to LaundryGo\'s service terms: items are inspected on intake, and any pre-existing damage is documented and shared with you before processing.',
                'Cancellations made before pickup are free of charge. Delivery windows are estimates and may shift with traffic or partner capacity.',
                'Payment is captured at checkout via your selected method; refunds for cancelled or disputed orders are processed within 5 business days.',
              ],
            ),
            AppRoutes.search: (_) => const SearchScreen(),
            AppRoutes.garmentCatalogue: (_) => const GarmentCatalogueScreen(),
            AppRoutes.appearance: (_) => const AppearanceScreen(),
            AppRoutes.notifications: (_) => const NotificationsScreen(),
            AppRoutes.partnerCatalogue: (_) => const PartnerCatalogueScreen(),
            AppRoutes.about: (_) => const AboutScreen(),
            AppRoutes.signUp: (_) => const SignUpScreen(),
            AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
            AppRoutes.settings: (_) => const SettingsScreen(),
            AppRoutes.partnerHome: (_) => const PartnerShell(),
            AppRoutes.driverHome: (_) => const DriverShell(),
            AppRoutes.adminLogin: (_) => const AdminLoginScreen(),
            AppRoutes.adminHome: (_) => const AdminShell(),
            AppRoutes.root: (_) => const SplashScreen(),
          },
          onGenerateRoute: (settings) {
            // `settings.arguments` is null on a direct URL visit or page
            // refresh (no prior `pushNamed` call carried a partner id) —
            // fall back to the first mock partner instead of crashing, so
            // a refreshed/bookmarked deep link still renders something.
            final partnerId =
                settings.arguments as String? ??
                MockCustomerData.partners.first.id;
            if (settings.name == AppRoutes.partnerDetail) {
              return MaterialPageRoute(
                builder: (_) => PartnerDetailScreen(partnerId: partnerId),
                settings: settings,
              );
            }
            if (settings.name == AppRoutes.schedulePickup) {
              return MaterialPageRoute(
                builder: (_) => SchedulePickupScreen(partnerId: partnerId),
                settings: settings,
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
