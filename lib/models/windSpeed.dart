class WindSpeedBeaufort {
   int? id;
   int? minSpeed;
   int? maxSpeed;
   String? description;
   String? seaEffect;
   String? waveEffect;

  WindSpeedBeaufort({this.id, this.minSpeed, this.maxSpeed, this.description,
      this.seaEffect, this.waveEffect});

       factory WindSpeedBeaufort.fromJson2(Map<String, dynamic> json) {
    return WindSpeedBeaufort(
      id: json['id'],
      minSpeed: json['min_speed'],
      maxSpeed: json['max_speed'],
      description: json['description'],
      seaEffect: json['sea_effect'],
      waveEffect: json['wave_effect'],
    );
  }

   WindSpeedBeaufort.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      minSpeed = json['min_speed'];
      maxSpeed = json['max_speed'];
      description = json['description'];
      seaEffect = json['sea_effect'];
      waveEffect = json['wave_effect'];
  }
  // Fonction toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'min_speed': minSpeed,
      'max_speed': maxSpeed,
      'description': description,
      'sea_effect': seaEffect,
      'wave_effect': waveEffect,
    };
  }
}

final List<WindSpeedBeaufort> windSpeedBeauforts = [
  WindSpeedBeaufort(
    id: 0,
    minSpeed: 0,
    maxSpeed: 1,
    description: "",
    seaEffect: "",
    waveEffect: ""
    ),
  WindSpeedBeaufort(
    id: 1,
    minSpeed: 0,
    maxSpeed: 1,
    description: "Pas de vent",
    seaEffect: "Pas de vent",
    waveEffect: "Pas de vent"
    ),
  WindSpeedBeaufort(
    id: 2,
    minSpeed: 0,
    maxSpeed: 1,
    description: "Calme",
    seaEffect: "Mer lisse",
    waveEffect: "Pas de vagues"
    ),
  WindSpeedBeaufort(
     id: 3,
     minSpeed: 1,
     maxSpeed: 3,
     description: "Très légère brise",
     seaEffect: "Très Petites rides",
     waveEffect: "Petites vagues, comme des rides"
     ),
  WindSpeedBeaufort(
     id: 4,
     minSpeed: 4,
     maxSpeed: 6,
     description: "Légère brise",
     seaEffect: "Petites rides",
     waveEffect: "Très petites vagues"
     ),
  WindSpeedBeaufort(
      id: 5,
      minSpeed: 7,
      maxSpeed: 10,
      description: "Pétite brise",
      seaEffect: "Petites vagues",
      waveEffect: "Petites vagues, clapotis"
      ),
  WindSpeedBeaufort(
    id: 6,
    minSpeed: 11,
    maxSpeed: 16,
    description: "Jolie brise",
    seaEffect: "Creux plus importants",
    waveEffect: "Vagues courtes et bien formées"
    ),
  WindSpeedBeaufort(
    id: 7,
    minSpeed: 17,
    maxSpeed: 21,
    description: "Bonne brise",
    seaEffect: "Petites vagues courtes",
    waveEffect: "Vagues plus grandes, écume plus visible"
    ),
  WindSpeedBeaufort(
    id: 8,
    minSpeed: 22,
    maxSpeed: 27,
    description: "Vent frais",
    seaEffect: "Mer agitée",
    waveEffect: "Vagues longues et déferlantes"
    ),
  WindSpeedBeaufort(
    id: 9,
    minSpeed: 28,
    maxSpeed: 33,
    description: "Grand frais",
    seaEffect: "Houle forte",
    waveEffect: "Vagues déferlantes avec écume blanche"),
  WindSpeedBeaufort(
    id: 10,
    minSpeed: 34,
    maxSpeed: 40,
    description: "Coup de vent",
    seaEffect: "Mer très agitée",
    waveEffect: "Vagues très grandes et déferlantes, embruns importants"
    ),
];


