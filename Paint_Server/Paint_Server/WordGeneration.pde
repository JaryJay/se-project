Map<String, List<String>> categoryToWords = new HashMap<String, List<String>>();

void initWordGeneration() {
  String[] categoryInfoLines = loadStrings("words.txt");
  for (String categoryInfo : categoryInfoLines) {
    String category = categoryInfo.split(":")[0];
    List<String> words = Arrays.asList(categoryInfo.split(":")[1].split(","));
    categoryToWords.put(category, words);
  }
}

String generateWordFrom(String category) {
  List<String> wordsInCategory = categoryToWords.get(category.replaceAll("_", " "));
  return wordsInCategory.get(int(random(wordsInCategory.size())));
}
