class Anime {
  int Id =0;
  String Name='';
  String Img='';

  Anime({
    required this.Id,
    required this.Name,
    required this.Img});

  Anime.fromJson(Map<String, dynamic> json) {
    Id = json['anime_id'];
    Name = json['anime_name'];
    Img = json['anime_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> anime = new Map<String, dynamic>();
    anime['anime_id'] = this.Id;
    anime['anime_name'] = this.Name;
    anime['anime_img'] = this.Img;
    return anime;
  }
}