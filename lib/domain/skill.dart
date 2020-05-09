enum Skill { Beginner, Intermediate, Expert, Custom }

class Difficulty {
  final int width;
  final int height;
  final int bombs;

  const Difficulty(this.width, this.height, this.bombs)
      : assert(width > 0),
        assert(height > 0),
        assert(bombs > 0),
        assert(bombs <= width * height);

  @override
  String toString() => "$width x $height ($bombs bombs)";
}

extension SkillExtension on Skill {
  Difficulty get difficulty {
    switch (this) {
      case Skill.Beginner:
        return Difficulty(10, 10, 8);

      case Skill.Intermediate:
        return Difficulty(16, 16, 40);

      case Skill.Expert:
        return Difficulty(24, 24, 99);

      default:
        return null;
    }
  }
}
