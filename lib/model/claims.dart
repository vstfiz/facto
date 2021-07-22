class Claims {
  String requestedBy;
  String date;
  String news;
  String status;
  String factCheck;
  bool isSelected;
  String url1;
  String url2;
  String type;
  bool isFeed;
  String factCheckBy;
  String claimId;
  String description;
  String language;
  String geo;
  String category;
  String truth;
  var tags = [];
  String comment;

  Claims(this.requestedBy, this.date, this.news, this.status, this.factCheck,this.isSelected,this.claimId);

  Claims.forHome(this.factCheckBy,this.news,this.factCheck);

  Claims.fromId(this.requestedBy,this.date, this.news, this.url1, this.url2, this.type,
      this.description, this.language, this.geo, this.category, this.truth,
      this.tags,this.comment);
}
