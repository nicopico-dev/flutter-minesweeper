import 'package:flutter/material.dart';
import 'package:minesweeper/domain/skill.dart';
import 'package:minesweeper/screen/shared/numeric_form_field.dart';

class CustomDifficultyForm extends StatefulWidget {
  final bool enabled;
  final Difficulty difficulty;
  final GlobalKey formKey;

  CustomDifficultyForm({
    Key key,
    @required this.difficulty,
    this.formKey,
    this.enabled = true,
  }) : super(key: key);

  @override
  _CustomDifficultyFormState createState() => _CustomDifficultyFormState();
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
          readOnly: widget.enabled,
          controller: _widthController,
        ),
        NumericFormField(
          hintText: "hauteur",
          icon: Icon(Icons.swap_vert),
          readOnly: widget.enabled,
          controller: _heightController,
        ),
        NumericFormField(
          hintText: "bombes",
          icon: Image.asset(
            "assets/images/bomb.png",
            scale: 1.5,
            color: Colors.grey,
          ),
          readOnly: !widget.enabled,
          controller: _bombsController,
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
}
