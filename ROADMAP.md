# CraftDeja — nächste Schritte

Stand: 23.11.2026. Funktionsstand: PROJECT_STATE.md.
Priorisierte Planung; Abnahmekriterien und Belege: [docs/OPEN_ITEMS.md](docs/OPEN_ITEMS.md).

- **Beschaffung und Serien (PROC-27)** im Forever-Client abnehmen. Beim Händler und im AH dieselbe Rezeptvorschau mit dem aktiven Beruf prüfen. Beim grünen Zauberstab und bei Kochkunst den Einkauf und die tatsächlich vorbereitete Serie vergleichen.

- **Zielbestände im Hauptfenster (STOCK-UI):** Berufsübergreifende Liste, neue Rezepte,
  `/reload`, Charakterwechsel und verfügbare Bezugswege in Forever prüfen. Einen
  Auffüllauftrag beenden und den Wechsel zwischen Materialwahl und Optionen nachstellen.

1. **Live-Abnahme beta.26 (ENG-300-LIVE, GUIDE-DEV):** Kauf/Post/Händler/Craft, den
   Übergang 75/75 → 75/150 und eine Herstellung ohne Skillpunkt im Forever-Client
   gegen die Checkliste in TEST_RESULTS.md prüfen. Für die höheren Ränge bei Bedarf
   einen passenden Testcharakter einsetzen.
2. **Materialquellen (LIVE-25):** Bank/AH-Auswahl, Post und native Zwischenherstellung
   unter echten Forever-Bedingungen prüfen.
3. **Kompatibilität (LIVE-24, UI-LIVE):** Undercity-Gesamtfluss, Giftzugang, Bank mit TSM
   sowie Workshop/Guide mit realem Addonset und Skalierungen abnehmen.
4. **Release-Nachpflege (PUB-DESC):** Option D mit aktuellen Live-Medien vorbereiten und die freigegebene Seite zu einem separaten Auftrag
   in der Author Console übernehmen. Öffentliche Vorschau und Kurzbeschreibung prüfen.
5. **Datenqualität (DATA-STATIONS, DATA-VENDORS):** Verifizierte Forever-Standorte und
   Quellenherkunft ausbauen. Wöchentlichen externen Händlerrezept-Diff erst mit belastbarer
   Datenquelle und fachlicher Freigabe einrichten. Kein globaler Ingame-Poll.
6. **Wirtschaftlichkeit (MODEL-VALIDATION):** Skillchancen und komplette Routen mit echten
   Beobachtungen/unabhängigen Referenzfällen validieren. Noch fehlende Rang-/Reise-/Werkzeugkosten
   sowie optionale riskante AH-Verkaufserlöse gesondert konzipieren.
7. **Produkt und Rückmeldungen:** Werkstattbanner von Option D einbinden (PROMO-HERO). Neues Logo/Icon aus docs/assets/branding/2026-11-17/ bei gewünschter
   Übernahme passend exportieren und getrennt prüfen (BRAND-LOGO). Echte Durchlaufaufnahme, strukturierte Nutzerfälle und
   verständliche Preis-/Quellennachweise priorisieren; keine unbelegten Rankings/Ersparnisse.

Übergabestruktur und Projektcheck sind umgesetzt; technische Prüfung: docs/PROJECT_CONTEXT.md.
Der Guide-Teststand ist lokal als Release-Profil zur Live-Abnahme installiert.
Frühere Wünsche bleiben im [Archiv](docs/archive/2026-11-17-handoff/ROADMAP.md).
Bei Wiederaufnahme mit Code abgleichen: alte Checkboxen können inzwischen teilweise erfüllt sein.
