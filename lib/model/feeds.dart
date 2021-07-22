class Feeds {
  String claim;
  String truth;
  String url1;
  var tags;
  String geo;
  String language;
  String category;
  String url2;
  String claimId;
  bool feedType;
  bool isClaim;
  bool isFeed;
  String time;
  String status;
  String requestedBy;
  bool isSelected;
  String publisher;
  int impressions;
  int clicks;

  Feeds(
      this.claim,
      this.truth,
      this.url1,
      this.tags,
      this.geo,
      this.language,
      this.category,
      this.url2,
      this.claimId,
      this.feedType,
      this.isFeed,
      this.time,
      this.status,
      this.requestedBy);

  Feeds.forReview(this.requestedBy, this.time, this.claim,this.isSelected,this.claimId,this.feedType);

  Feeds.published(this.claim, this.language, this.feedType, this.time, this.status,
      this.publisher, this.impressions, this.clicks,this.claimId);
}
