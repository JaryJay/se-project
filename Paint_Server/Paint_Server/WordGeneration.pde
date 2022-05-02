Map<String, List<String>> categoryToWords = new HashMap<>();

void initWordGeneration() {
  String[] categoryInfoLines = loadStrings("category.txt");
  for (String categoryInfo : categoryInfoLines) {
    String category = categoryInfo.split(":")[0];
    List<String> words = Arrays.asList(categoryInfo.split(":")[1].split(","));
    categoryToWords.put(category, words);
  }
}

String generateWordFrom(String category) {
  List<String> wordsInCategory = categoryToWords.get(category);
  return wordsInCategory.get(int(random(wordsInCategory.size())));
}
