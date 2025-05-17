

class Option {

  String id;
  String name;
  int? votes;

  Option({
   required this.id,
    required this.name,
     this.votes
  });

  factory Option.fromMap( Map<String, dynamic> obj ) 
    => Option(
      id   : obj.containsKey('id') ? obj['id'] : 'no-id',
      name : obj.containsKey('name') ? obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes'
    );
  


}