String? dateExtractor(fullDate) {
  if (fullDate == null) return null;
  return fullDate.split(' ')[0];
}