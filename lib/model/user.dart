class User {
  String name;
  String email;
  String dp;
  String uid;
  int factCheck;
  int feeds;

  User(this.name, this.email,
      this.dp, this.uid);

  User.forHome(this.name, this.factCheck, this.feeds);

  String toString(){
    return this.name + "   " + this.email + "    " + this.uid + "     " + this.dp;
  }
}