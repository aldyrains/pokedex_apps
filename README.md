# pokedex_apps

**Deskripsi singkat**
Aplikasi Pokedex sederhana berbasis Flutter yang memanfaatkan GraphQL Pokemon API (`https://graphql-pokemon2.vercel.app/`). Aplikasi ini di-desain dengan GetX + arsitektur terpisah (domain / infrastructure / presentation) agar mudah diuji dan dipelihara.

---

## Fitur

* Infinite scroll list of Pokemons (pagination menggunakan `take` & `offset`).
* Pokemon detail page (informasi dasar, attacks, evolutions jika tersedia).
* Struktur modular & binding GetX untuk routing dan dependency injection.
* Error handling dan loading states.

(Opsional yang belum diimplementasikan bisa berupa filter by type, caching persisten, offline support.)

---

## Struktur proyek (singkat)

Struktur ini merefleksikan folder yang ada di `lib/`:

```
lib/
  domain/
    core/interfaces/
  infrastructure/
    dal/
      daos/
    services/
  navigation/
    bindings/
      controllers_bindings.dart
      home.controller.binding.dart
    controllers/
      home.controller.dart
    domains/
    navigation.dart
    routes.dart
  presentation/
    home/
      controllers/
        home.controller.dart
      home.screen.dart
    screens.dart
  theme/
  main.dart
```

Penjelasan singkat per layer:

* **domain**: entitas, interface repository, usecase. Logika bisnis murni.
* **infrastructure**: implementasi datasource, client GraphQL wrapper, DAO jika butuh local cache.
* **navigation**: binding GetX, route definition dan inisialisasi dependency.
* **presentation**: pages/screens, controllers GetX, widget UI.

---

## Requirement (development)

* Flutter SDK (stable) — rekomendasi: versi 3.x atau yang stabil terbaru saat development.
* Android SDK & toolchain untuk build APK.
* `flutter pub get` akan meng-install dependency.

**Dependencies utama yang direkomendasikan** (cek `pubspec.yaml` di repo):

* get: GetX (state / routing / DI)
* graphql\_flutter (GraphQL client)
* freezed / json\_serializable (opsional untuk model generation)
* cached\_network\_image
* flutter\_lints
* mocktail / mockito (testing)

---

## Cara build & run (development)

1. Clone repo

```bash
git clone <REPO_URL>
cd POKEDEX_APPS
```

2. Install dependency

```bash
flutter pub get
```

3. Run di device/emulator

```bash
flutter run
```

### Build APK (release)

```bash
flutter build apk --release
```

Jika ingin menghasilkan APK yang signed untuk distribusi, ikuti langkah signing Flutter standar (atur `key.properties`, `signingConfigs` di `android/app/build.gradle`).

---

## Konfigurasi GraphQL

Endpoint default yang digunakan:

```
https://graphql-pokemon2.vercel.app/
```

Contoh query pagination (ambil 20):

```graphql
query getPokemons($take: Int!, $offset: Int!) {
  getAllPokemon(take: $take, offset: $offset) {
    id
    number
    name
    image
    types
    classification
  }
}
```

Contoh query detail:

```graphql
query getPokemon($name: String) {
  pokemon(name: $name) {
    id
    number
    name
    image
    types
    classification
    maxCP
    maxHP
    attacks {
      fast { name type damage }
      special { name type damage }
    }
    evolutions { id number name image types }
  }
}
```

**Catatan tentang filter**: API ini menyediakan `take` dan `offset`. Jika ingin filter by `types` dan server tidak mendukung filter, filter dapat dilakukan client-side (dengan tradeoff: lebih banyak data ditransfer). Selalu batasi field yang di-request untuk mengurangi payload.

---

## Implementasi pagination (catatan teknis)

* Gunakan `ScrollController` pada screen list.
* Trigger `loadNext()` saat posisi scroll mendekati bottom.
* Controller menjaga `isLoading`, `offset`, `take`, `hasMore`.
* Jika batch yang diterima < `take`, set `hasMore = false`.

---

## Testing

Jalankan unit & widget test:

```bash
flutter test
```
