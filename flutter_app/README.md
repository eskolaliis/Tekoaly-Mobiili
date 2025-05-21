# Ruokavinkki

Tämä on Flutterilla toteutettu mobiilisovellus, joka auttaa käyttäjää keksimään reseptejä sen perusteella, mitä ainesosia kaapista löytyy.

---

## Projektin tavoite

Sovelluksen tarkoitus on:
- Tarjota käyttäjälle ruokareseptejä yksinkertaisilla syötteillä
- Mahdollistaa reseptien tallentaminen suosikeiksi
- Antaa mahdollisuus lisätä kuva omasta toteutuksesta
- Toimia täysin ilman ulkoista tekoälyrajapintaa (offline-logiikalla)

---

## Ominaisuudet

- Ainesosien syöttö ja muokkaus
- Reseptiehdotusten generointi paikallisesti
- Suosikkireseptien tallennus ja järjestäminen
- Kuvan lisääminen suosikeille
- Tumma / vaalea tila (teema-asetus)
- Splash screen ja oma sovellusikoni
- Tietojen tallennus SharedPreferences-muistiin

---

## Teknologiat

- Flutter (3.29+)
- Dart
- SharedPreferences (paikallinen tallennus)
- Image Picker (galleria / kamera)
- Flask (Python, reseptipalvelin)

---

## Asennus ja käyttö

1. Varmista, että sinulla on Flutter (3.29+) ja Python 3 asennettuna.
2. Kloonaa projekti:
```bash
git clone https://github.com/eskolaliis/Tekoaly-Mobiili.git
```

3. Aja backend:
```bash
cd backend
pip install flask flask-cors
python3 app.py
```

4. Aja Flutter-sovellus:
```bash
cd flutter_app
flutter pub get
flutter run
```

> Varmista, että backend on päällä ennen kuin painat "Ehdota reseptejä".


---

## Tekijä

**Nimi:** Liis Eskola 
**Kurssi:** Projekti: Tekoäly / Mobiili  
**Pvm:** 20.05.2025