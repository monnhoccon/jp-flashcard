class DisplayedWordSize {
  double furiganaFontSize;
  double textFontSize;

  static large() {
    return DisplayedWordSize(
      furiganaFontSize: 15,
      textFontSize: 35,
    );
  }

  static medium() {
    return DisplayedWordSize(
      furiganaFontSize: 9,
      textFontSize: 21,
    );
  }

  DisplayedWordSize({
    this.furiganaFontSize,
    this.textFontSize,
  });
}
