/// 長期利用者向けオファーで提示するプラン。
enum LifetimeOfferPlan {
  lifetime('lifetime'),
  monthly300('monthly_300');

  const LifetimeOfferPlan(this.analyticsValue);

  final String analyticsValue;
}
