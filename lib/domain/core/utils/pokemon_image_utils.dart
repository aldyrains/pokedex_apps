String padNumber(String numberRaw) {
  final n = int.tryParse(numberRaw.replaceAll(RegExp(r'[^0-9]'), '')) ?? -1;
  if (n < 0) return numberRaw;
  return n.toString().padLeft(3, '0');
}

String buildOfficialPokedexUrl(String numberRaw) {
  final padded = padNumber(numberRaw);
  return 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/$padded.png';
}