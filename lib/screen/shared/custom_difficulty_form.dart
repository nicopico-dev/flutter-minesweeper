import 'package:flutter/material.dart';
import 'package:minesweeper/domain/skill.dart';
import 'package:minesweeper/screen/shared/numeric_form_field.dart';

class CustomDifficultyForm extends StatefulWidget {
  final GlobalKey formKey;
  final bool enabled;
  final Difficulty difficulty;
  final DifficultyReader reader;

  CustomDifficultyForm({
    Key key,
    this.formKey,
    @required this.difficulty,
    this.enabled = true,
    this.reader,
  }) : super(key: key) {
    reader?.initWith(difficulty);
  }

  @override
  _CustomDifficultyFormState createState() => _CustomDifficultyFormState();
}

class DifficultyReader {
  int _width;
  int _height;
  int _bombs;

  set width(int value) => _width = value;
  set height(int value) => _height = value;
  set bombs(int value) => _bombs = value;

  Difficulty get value => Difficulty(_width, _height, _bombs);

  void initWith(Difficulty difficulty) {
    _width = difficulty.width;
    _height = difficulty.height;
    _bombs = difficulty.bombs;
  }
}

class _CustomDifficultyFormState extends State<CustomDifficultyForm> {
  GlobalKey _formKey;

  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _bombsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormState>();
    _setFormContent(widget.difficulty);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        NumericFormField(
          hintText: "largeur",
          icon: Icon(Icons.swap_horiz),
          enabled: widget.enabled,
          validator: (value) => value.isEmpty || int.parse(value) <= 0
              ? "La largeur doit être supérieure à 0"
              : null,
          controller: _widthController,
          onSaved: (value) => widget.reader?.width = value,
        ),
        NumericFormField(
          hintText: "hauteur",
          icon: Icon(Icons.swap_vert),
          enabled: widget.enabled,
          validator: (value) => value.isEmpty || int.parse(value) <= 0
              ? "La hauteur doit être supérieure à 0"
              : null,
          controller: _heightController,
          onSaved: (value) => widget.reader?.height = value,
        ),
        NumericFormField(
          hintText: "bombes",
          icon: _BombIcon(),
          enabled: widget.enabled,
          validator: (value) {
            if (value.isEmpty) {
              return "Veuillez saisir une valeur";
            } else if (int.parse(value) >= _computeGridSize()) {
              return "Trop de bombes !";
            } else {
              return null;
            }
          },
          controller: _bombsController,
          onSaved: (value) => widget.reader?.bombs = value,
        )
      ]),
    );
  }

  @override
  void didUpdateWidget(CustomDifficultyForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setFormContent(widget.difficulty);
  }

  void _setFormContent(Difficulty difficulty) {
    if (difficulty == null) return;
    _widthController.text = difficulty.width?.toString();
    _heightController.text = difficulty.height?.toString();
    _bombsController.text = difficulty.bombs?.toString();
  }

  int _computeGridSize() {
    return (int.tryParse(_widthController.text) *
            int.tryParse(_heightController.text)) ??
        0;
  }
}

class _BombIcon extends StatelessWidget {
  const _BombIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconTheme = IconTheme.of(context);
    return Image.asset(
      "assets/images/bomb.png",
      scale: 1.5,
      color: iconTheme.color,
    );
  }
}
