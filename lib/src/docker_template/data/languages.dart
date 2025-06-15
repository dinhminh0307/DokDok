class Languages {
  int? _languageId;
  String? _languageName;

  Languages({
    int? language_id,
    String? language_name,
  })  : _languageId = language_id,
        _languageName = language_name;

  // Getter for languageId
  int? get languageId => _languageId;

  // Setter for languageId
  set languageId(int? value) {
    _languageId = value;
  }

  // Getter for languageName
  String? get languageName => _languageName;

  // Setter for languageName
  set languageName(String? value) {
    _languageName = value;  
  }
}