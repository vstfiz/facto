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

  Claims(this.requestedBy, this.date, this.news, this.status, this.factCheck,this.isSelected,this.claimId);

  Claims.forHome(this.factCheckBy,this.news,this.factCheck);
}
