class DisplayedWordSettings {
  double furiganaFontSize;
  double textFontSize;

  static large() {
    return DisplayedWordSettings(
      furiganaFontSize: 15,
      textFontSize: 35,
    );
  }

  static medium() {
    return DisplayedWordSettings(
      furiganaFontSize: 9,
      textFontSize: 21,
    );
  }

  DisplayedWordSettings({
    this.furiganaFontSize,
    this.textFontSize,
  });
}
