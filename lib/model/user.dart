class User {
  String name;
  String email;
  String dp;
  String uid;
  int factCheck;
  int feeds;
  String status;
  String role;

  User(this.name, this.email,
      this.dp, this.uid);

  User.forHome(this.name, this.factCheck, this.feeds);

  User.forManage(this.name,this.uid,this.status,this.role, this.factCheck,this.feeds);

  String toString(){
    return this.name + "   " + this.email + "    " + this.uid + "     " + this.dp;
  }
}