import 'package:connect_mi/pages/home.dart';
import 'package:connect_mi/pages/landing.dart';
import 'package:connect_mi/pages/remote.dart';
import 'package:connect_mi/utils/preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: remotePageRoute,
  redirect: (BuildContext context, GoRouterState state) {
    if (PreferencesManager().getMiLightHubUrl() == '') {
      return landingPageRoute;
    } else {
      return null;
    }
  },
  routes: <RouteBase>[
    GoRoute(
      path: landingPageRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const LandingPage();
      },
    ),
    GoRoute(
      path: homePageRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: remotePageRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const RemotePage();
      },
    ),
  ],
);

//Define all the routing urls.
const homePageRoute = "/home";
const landingPageRoute = "/";
const remotePageRoute = "/remote";
