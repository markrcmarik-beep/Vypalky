# Changelog

Přehled změn balíčku `Vypalky` podle verzí zaznamenaných v historii `Project.toml`.

## [0.1.1] - 2026-11-06

### Přidáno
- README a dokumentace k instalaci, použití a exportovaným funkcím.
- Pomocné skripty pro vývoj, testování, aktualizaci a sestavení dokumentace.
- Soubor nápovědy balíčku `Vypalky.md`
### Upraveno
- Opravy a zjednodušení výpočtu rozvinuté délky plechu.
- Úpravy testů a pravidel `.gitignore`.
- Odstraněno verzování používaných balíčků.

## [0.1.0] - 2026-03-14

### Přidáno
- První verze balíčku se dvěma funkcemi:
  - `vypalek()` pro výpočet plochy průřezu a hmotnosti kruhového nebo obdélníkového vypalku, případně s otvorem.
  - `rozvin()` pro výpočet rozvinuté délky plechu metodami K-factor, neutral, BA a BD.
