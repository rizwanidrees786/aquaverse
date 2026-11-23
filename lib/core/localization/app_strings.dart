class AppStrings {
  AppStrings(this.localeCode);

  final String localeCode;

  bool get isUrdu => localeCode.toLowerCase().startsWith('ur');

  String get appName => isUrdu ? 'ایکوا ورس' : 'AquaVerse';

  String get navHome => isUrdu ? 'ہوم' : 'Home';
  String get navAquariums => isUrdu ? 'ایکویریمز' : 'My Aquariums';
  String get navLivestock => isUrdu ? 'مچھلی اور حیات' : 'Fish & Livestock';
  String get navWaterLab => isUrdu ? 'واٹر لیب' : 'Water Lab';
  String get navTasks => isUrdu ? 'دیکھ بھال' : 'Care & Tasks';
  String get navInsights => isUrdu ? 'تجزیات' : 'Insights';
  String get navAi => isUrdu ? 'اے آئی معاون' : 'AI Assistant';
  String get navKnowledge => isUrdu ? 'نالج سینٹر' : 'Knowledge Center';
  String get navInventory => isUrdu ? 'انوینٹری' : 'Inventory';
  String get navMarketplace => isUrdu ? 'مارکیٹ پلیس' : 'Marketplace';
  String get navBusiness => isUrdu ? 'بزنس' : 'Business';
  String get navSettings => isUrdu ? 'سیٹنگز' : 'Settings';

  String get dashboardTitle =>
      isUrdu ? 'ایکوا ورس کمانڈ ڈیش بورڈ' : 'AquaVerse Command Hub';
  String get dashboardSubtitle => isUrdu
      ? 'آپ کے ایکویریمز اور دیکھ بھال کا لائیو ڈیٹا بیس جائزہ'
      : 'Real-time offline database overview of your aquatic systems';
  String get moreModules => isUrdu ? 'مزید ماڈیولز' : 'All Ecosystem Modules';
}
