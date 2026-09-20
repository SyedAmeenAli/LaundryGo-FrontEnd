import 'laundrygo_asset_library.dart';

/// Central, screen-facing LaundryGo asset registry. Screens reference these
/// constants — never a raw `'assets/...'` string — so there is exactly one
/// place that knows where each image lives.
///
/// Two manifest categories in the supplied 155-image library are genuinely
/// empty (`02_Splash_Onboarding_Auth`, `03_Customer_Service_Imagery`) — not
/// fabricated. [onboarding] and [services] below are therefore empty lists;
/// screens needing that imagery use the closest real asset from an adjacent
/// group instead (documented at the call site), never an invented one.
class LaundryGoAssets {
  LaundryGoAssets._();

  // Production brand files — transparent-background PNGs, not part of the
  // 155-image photography library.
  static const logoMark = 'assets/brand/logo_mark.png';
  static const logoHorizontal = 'assets/brand/logo_horizontal.png';
  static const appIconRed = 'assets/brand/app_icon_red.png';
  static const appIconGreen = 'assets/brand/app_icon_green.png';
  static const appIconNavy = 'assets/brand/app_icon_navy.png';
  static const appIconWhite = 'assets/brand/app_icon_white.png';
  static const appIconTransparent = 'assets/brand/app_icon_transparent.png';

  /// User-supplied product shot for the Shoes Cleaning service tile —
  /// not part of the 155-image library, added directly to `assets/brand/`
  /// on explicit request.
  static const shoesCleaning = 'assets/brand/shoes_cleaning.jpg';

  // ---- Category groups (rule 9) ----
  static const List<String> brand = LaundryGoAssetLibrary.brand;

  /// GENUINE GAP — `02_Splash_Onboarding_Auth` is empty in the supplied
  /// library. Do not fabricate; onboarding screens draw from [oman] /
  /// [garments] / [human] instead.
  static const List<String> onboarding = <String>[];

  /// GENUINE GAP — `03_Customer_Service_Imagery` is empty in the supplied
  /// library. Do not fabricate; service tiles draw from [process] instead.
  static const List<String> services = <String>[];

  static const List<String> garments = LaundryGoAssetLibrary.garments;
  static const List<String> oman = LaundryGoAssetLibrary.oman;
  static const List<String> partner = LaundryGoAssetLibrary.partner;
  static const List<String> human = LaundryGoAssetLibrary.human;
  static const List<String> process = LaundryGoAssetLibrary.process;
  static const List<String> delivery = LaundryGoAssetLibrary.delivery;
  static const List<String> states = LaundryGoAssetLibrary.states;
  static const List<String> tracking = LaundryGoAssetLibrary.tracking;
  static const List<String> partnerApp = LaundryGoAssetLibrary.partnerApp;
  static const List<String> driverApp = LaundryGoAssetLibrary.driverApp;
  static const List<String> admin = LaundryGoAssetLibrary.admin;
  static const List<String> support = LaundryGoAssetLibrary.support;

  // ---- Curated single-image semantic constants ----

  // Garment catalog.
  static const tshirt = LaundryGoAssetLibrary.garmentTshirt;
  static const polo = LaundryGoAssetLibrary.garmentPolo;
  static const dressShirt = LaundryGoAssetLibrary.garmentDressShirt;
  static const trousers = LaundryGoAssetLibrary.garmentTrousers;
  static const jeans = LaundryGoAssetLibrary.garmentJeans;
  static const shorts = LaundryGoAssetLibrary.garmentShorts;
  static const skirt = LaundryGoAssetLibrary.garmentSkirt;
  static const blouse = LaundryGoAssetLibrary.garmentBlouse;
  static const abaya = LaundryGoAssetLibrary.garmentAbaya;
  static const abayaEmbroidered = LaundryGoAssetLibrary.garmentAbayaEmbroidered;
  static const dishdasha = LaundryGoAssetLibrary.garmentDishdasha;
  static const thobe = LaundryGoAssetLibrary.garmentThobe;
  static const jacket = LaundryGoAssetLibrary.garmentJacket;
  static const suit = LaundryGoAssetLibrary.garmentSuit;
  static const coat = LaundryGoAssetLibrary.garmentCoat;
  static const sweater = LaundryGoAssetLibrary.garmentSweater;
  static const bedsheet = LaundryGoAssetLibrary.garmentBedsheet;
  static const blanket = LaundryGoAssetLibrary.garmentBlanket;
  static const duvet = LaundryGoAssetLibrary.garmentDuvet;
  static const towel = LaundryGoAssetLibrary.garmentTowel;

  /// GENUINE GAP — no women's-dress catalog photo supplied
  /// (manifest `DEDICATED_SLOT_GAPS.md`, slot 039). No placeholder file
  /// exists in this fresh repo either; callers must fall back to
  /// [LaundryGoAssetLibrary.processFoldedClothingEditorial] via
  /// [garmentFor] rather than reference a `dress` constant that would
  /// point at nothing real.
  /// GENUINE GAP — no cap/hat photo supplied. Same fallback as [dress].
  /// GENUINE GAP — no pillowcase photo supplied. Same fallback.

  // Oman lifestyle.
  static const omanMuscatHero = LaundryGoAssetLibrary.omanMuscatHero;
  static const omanCoastline = LaundryGoAssetLibrary.omanMuscatCoastline;
  static const omanMountains = LaundryGoAssetLibrary.omanMountains;
  static const omanArchitecture = LaundryGoAssetLibrary.omanModernArchitecture;
  static const omanResidential = LaundryGoAssetLibrary.omanResidentialExterior;
  static const omanArchitecturalArch =
      LaundryGoAssetLibrary.omanArchitecturalArch;

  // Human / driver / delivery heroes.
  static const driverHero = LaundryGoAssetLibrary.driverHero;
  static const driverVehicle = LaundryGoAssetLibrary.driverVehicleSideProfile;
  static const deliveryCompleted = LaundryGoAssetLibrary.humanDeliveryCompleted;
  static const deliveryPackageAtDoor =
      LaundryGoAssetLibrary.driverDeliveryBagAtDoorway;

  // Driver App — one real photo per screen (13_Driver_App), a previously
  // untouched dedicated asset group.
  static const driverWithBag = LaundryGoAssetLibrary.driverWithLaundryBag;
  static const driverPickupScene = LaundryGoAssetLibrary.driverPickupScene;
  static const driverDeliveringScene =
      LaundryGoAssetLibrary.driverDeliveringLaundryScene;
  static const driverAtCustomerHome =
      LaundryGoAssetLibrary.driverAtCustomerHome;
  static const driverVehicleHero = LaundryGoAssetLibrary.driverVehicleHero;
  static const driverVanOnStreet = LaundryGoAssetLibrary.driverVanOnStreet;
  static const driverCompletionScene =
      LaundryGoAssetLibrary.driverCompletionScene;

  /// Circular driver-avatar portrait — `12_Partner_App/081`.
  static const driverPortrait =
      LaundryGoAssetLibrary.humanMaleDeliveryDriverPortrait;
  static const customerPortrait =
      LaundryGoAssetLibrary.humanMaleCustomerPortrait;

  /// Second real portrait for Admin's driver/staff lists, so the fleet
  /// isn't every entry reusing [driverPortrait] — `05_Oman_Lifestyle`.
  static const driverPortraitFemale =
      LaundryGoAssetLibrary.omanFemaleDeliveryStaffPortrait;

  /// Second real customer portrait for Admin's customer list —
  /// `05_Oman_Lifestyle`.
  static const customerPortraitFemale =
      LaundryGoAssetLibrary.omanFemaleCustomerPortrait;

  // Admin App — real photography from the dedicated `14_Admin` group (plus
  // one `15_Additional_Support` asset explicitly tagged for Admin use).
  static const adminPartnerPerformance =
      LaundryGoAssetLibrary.adminPartnerPerformanceVisual;
  static const adminCustomerSupport =
      LaundryGoAssetLibrary.adminCustomerSupportVisual;
  static const adminPaymentsSupport =
      LaundryGoAssetLibrary.adminPaymentsSupportVisual;
  static const adminEmptyState = LaundryGoAssetLibrary.adminEmptyStateVisual;
  static const adminPartnerManagement =
      LaundryGoAssetLibrary.adminPartnerManagementVisual;
  static const adminAtmosphericBackground =
      LaundryGoAssetLibrary.adminAtmosphericBackground;

  // User-supplied customer portraits — one real distinct face per named
  // customer in the mock data, not part of the 155-image library, added
  // directly to `assets/brand/customers/` on explicit request (previously
  // every named customer shared a single reused portrait).
  static const customerFatima = 'assets/brand/customers/fatima_al_rawahi.jpg';
  static const customerMariam = 'assets/brand/customers/mariam_al_zadjali.jpg';
  static const customerSultan = 'assets/brand/customers/sultan_al_habsi.jpg';
  static const customerLayla = 'assets/brand/customers/layla_al_farsi.jpg';
  static const customerAhmed = 'assets/brand/customers/ahmed_al_balushi.jpg';
  static const customerYousuf = 'assets/brand/customers/yousuf_al_harthy.jpg';

  /// The branded "LAUNDRY GO" pickup bag at an Omani archway doorway —
  /// `13_Driver_App/152`. The strongest real asset for "right to your
  /// door" (onboarding page 3): it's literally a LaundryGo product shot in
  /// an Omani setting, not just a generic delivery scene.
  static const brandedBagAtOmaniDoorway =
      LaundryGoAssetLibrary.driverCustomerDoorstep;

  // Process / laundry.
  static const washingMachine = LaundryGoAssetLibrary.partnerWashingFacility;

  /// A literal in-drum washing-machine shot (distinct from [washingMachine],
  /// which is a partner-facility scene) — for onboarding's "Washing & Care"
  /// story, where the machine itself needs to be the visual subject.
  static const washingMachineWithLaundry =
      LaundryGoAssetLibrary.processWashingMachineWithLaundry;
  static const dryCleaningRack =
      LaundryGoAssetLibrary.partnerDryCleaningFacility;
  static const steamIron = LaundryGoAssetLibrary.processSteamIroningShirt;
  static const foldedStack =
      LaundryGoAssetLibrary.processFoldedClothingEditorial;

  // Textures — background/atmosphere layers, low-opacity use only.
  static const fabricTexture = LaundryGoAssetLibrary.fabricTextureLibrary;

  /// Red + green flowing-fabric duotone — Splash's cinematic dark
  /// background atmosphere (the "flowing white fabric + deep green
  /// fabric" the brief asks for, in one real supplied image).
  static const brandFabricDuotone = LaundryGoAssetLibrary.brandFabricDuotone;
  static const waterTexture = LaundryGoAssetLibrary.supportWaterTexture;
  static const ivoryTexture = LaundryGoAssetLibrary.ivoryTextureLibrary;

  // States.
  static const emptyCart = LaundryGoAssetLibrary.stateEmptyCart;
  static const noOrders = LaundryGoAssetLibrary.stateNoOrders;
  static const noSavedAddress = LaundryGoAssetLibrary.stateNoSavedAddress;
  static const noNotifications = LaundryGoAssetLibrary.stateNoNotifications;
  static const noSearchResults = LaundryGoAssetLibrary.stateNoSearchResults;
  static const noNearbyPartners =
      LaundryGoAssetLibrary.stateNoNearbyPartnersScene;
  static const partnerUnavailable =
      LaundryGoAssetLibrary.statePartnerUnavailable;
  static const offline = LaundryGoAssetLibrary.stateOffline;
  static const networkError = LaundryGoAssetLibrary.stateNetworkError;
  static const paymentSuccess = LaundryGoAssetLibrary.statePaymentSuccess;
  static const paymentFailure = LaundryGoAssetLibrary.statePaymentFailure;
  static const cancellationCompleted =
      LaundryGoAssetLibrary.stateCancellationCompleted;
  static const issueReportSubmitted =
      LaundryGoAssetLibrary.stateIssueReportSubmitted;

  // Partner storefront photos — real assets. Only 2 dedicated exterior
  // shots exist in the library (071/072); storefront3/4 reuse real
  // interior/facility shots rather than fabricate more exteriors.
  static const partnerStorefront1 =
      LaundryGoAssetLibrary.partnerStorefrontPrimary;
  static const partnerStorefront2 =
      LaundryGoAssetLibrary.partnerStorefrontVariation;
  static const partnerStorefront3 =
      LaundryGoAssetLibrary.partnerLaundryInterior;
  static const partnerStorefront4 =
      LaundryGoAssetLibrary.partnerLaundryFacilitySecondary;
  static const partnerAboutPhoto = LaundryGoAssetLibrary.partnerFoldingStation;

  // Partner App — one real photo per operational workflow stage
  // (12_Partner_App), so the Partner product uses its own dedicated,
  // previously-untouched asset group rather than reusing Customer shots.
  static const partnerStaffOperating =
      LaundryGoAssetLibrary.partnerStaffOperatingFacility;
  static const partnerOrganizing =
      LaundryGoAssetLibrary.partnerEmployeeOrganizingLaundry;
  static const partnerSortingOrders =
      LaundryGoAssetLibrary.partnerEmployeeSortingCustomerOrders;
  static const partnerQualityControl =
      LaundryGoAssetLibrary.partnerQualityControlScene;
  static const partnerPreparingPackage =
      LaundryGoAssetLibrary.partnerStaffPreparingPackage;
  static const partnerServiceScene =
      LaundryGoAssetLibrary.partnerServicePhotography;
  static const partnerPackaging = LaundryGoAssetLibrary.partnerPackagingScene;
  static const partnerHandoff = LaundryGoAssetLibrary.partnerCustomerOrderScene;
  static const partnerInspection =
      LaundryGoAssetLibrary.partnerInspectionWorkstation;
  static const partnerFinishedShelf =
      LaundryGoAssetLibrary.partnerFinishedOrderShelf;
  static const partnerProcessing = LaundryGoAssetLibrary.partnerOrderProcessing;
  static const partnerDriverPortrait =
      LaundryGoAssetLibrary.humanMaleDeliveryDriverPortrait;

  static const _partnerPhotos = [
    partnerStorefront1,
    partnerStorefront2,
    partnerStorefront4,
  ];

  static String partnerPhotoFor(String partnerId) =>
      _partnerPhotos[partnerId.hashCode.abs() % _partnerPhotos.length];

  /// Best-match garment photo for a free-text catalog item name. Falls
  /// back to a generic folded-laundry shot for the genuine gaps (dress,
  /// cap, pillowcase) rather than referencing a nonexistent asset.
  static String garmentFor(String itemName) {
    final n = itemName.toLowerCase();
    if (n.contains('bedsheet') || n.contains('sheet')) return bedsheet;
    if (n.contains('blanket')) return blanket;
    if (n.contains('duvet')) return duvet;
    if (n.contains('towel')) return towel;
    if (n.contains('abaya')) return abaya;
    if (n.contains('dishdasha') || n.contains('thobe') || n.contains('kandura'))
      return dishdasha;
    if (n.contains('suit')) return suit;
    if (n.contains('jacket')) return jacket;
    if (n.contains('coat')) return coat;
    if (n.contains('sweater') || n.contains('jumper')) return sweater;
    if (n.contains('dress shirt')) return dressShirt;
    if (n.contains('shirt')) return dressShirt;
    if (n.contains('blouse')) return blouse;
    if (n.contains('polo')) return polo;
    if (n.contains('jean')) return jeans;
    if (n.contains('trouser') || n.contains('pant')) return trousers;
    if (n.contains('short')) return shorts;
    if (n.contains('skirt')) return skirt;
    if (n.contains('t-shirt') || n.contains('tshirt')) return tshirt;
    return foldedStack; // dress / cap / pillowcase / anything unmatched
  }
}
