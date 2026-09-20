/// Shared breakpoint thresholds — every screen branches layout the same way
/// instead of each picking its own numbers.
class LGBreakpoints {
  LGBreakpoints._();

  static const double tablet = 768;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
  static const double maxContentWidth = 1480;

  static bool isMobile(double width) => width < tablet;
  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
}
