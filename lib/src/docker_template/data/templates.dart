class Templates {
  int? _template_id;
  String? _code;
  int? _program_id;

  Templates({
    int? template_id,
    String? code,
    int? program_id,
  })  : _template_id = template_id,
        _code = code,
        _program_id = program_id;

  int? get templateId => _template_id;
  String? get code => _code;
  int? get programId => _program_id;

  //setter
  set templateId(int? value) {
    _template_id = value;
  }

  set code(String? value) {
    _code = value;
  }

  set programId(int? value) {
    _program_id = value;
  }
}