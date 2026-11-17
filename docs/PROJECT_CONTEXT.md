# Projektkontext lesen und pflegen

## Arbeitsbeginn

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\Get-ProjectContext.ps1 -AsJson
```

Der Check liest nur lokale Dateien/Git und fragt Git/WoWLua-Versionen ab. Er verändert weder
PATH noch Dateien, startet keine Tests, prüft keine Spielprozesse und verbindet sich nicht mit
GitHub/CurseForge. Remote-URL ist Konfiguration, keine Bestätigung des Remote-Commits.
Credentials in HTTP-Remote-URLs werden ausgeblendet. Keine Tokens oder Umgebungsvariablen ausgeben.
ExecutionPolicy Bypass betrifft ausschließlich diesen Prozess; keine dauerhafte Systempolicy ändern.

- Arbeitsordner, Git-Root, Branch, HEAD, offene Änderungen und Addon-Version prüfen.
- Der Nachweisindex nennt exakt einen aktuellen Eintrag. Quell-, Test- und Inputhashes mit
  dessen Manifest vergleichen; neue Lua-/wowlua-Testdateien werden ebenfalls erkannt.
- `sourceStatus=match` bedeutet nur gleiche aufgezeichnete Bytes, keinen neuen Testlauf.
  `reportStatus=missing` bedeutet fehlender lokaler ZIP, auch wenn die Quellen passen.
  `verified_recorded_scope` erfordert passendes erfolgreiches Release-Ergebnis und ZIP-Hash.
- `-Strict` liefert bei Warnungen Exitcode1, z.B. fehlendem Bericht/Tool, ungültigem Manifest,
  geänderten Quellen oder detached HEAD. Offene Git-Änderungen werden angezeigt und bleiben
  erlaubt: ein neuer Arbeitsauftrag kann absichtlich vorhandene Änderungen enthalten.
- `-ProjectPath` ist für einen anderen vorhandenen Checkout vorgesehen. Nur vertrauenswürdige
  Projekte prüfen. Fehlendes/ungültiges wowlua.json oder Git-Fehler bricht die Aufnahme ab.
- Ein Hashunterschied wegen Checkout-Zeilenenden ist trotzdem ein Unterschied. Nicht still
  normalisieren; passenden Checkout verwenden oder neu prüfen. Grafik-/Paket-/Installations-
  und Liveprüfung bleiben eigene Nachweise.

## Zuständigkeit der Dateien

| Datei | Inhalt |
|---|---|
| AGENTS.md | Dauerhafte Arbeits-/Sicherheitsregeln und Einstieg |
| CONTINUE.md | Kurze aktuelle Übergabe, nächster Schritt, laufende Aufgabe |
| PROJECT_STATE.md | Aktuelle Funktionen, Release-/Installationsmomentaufnahme, Grenzen |
| DECISIONS.md | Geltende Entscheidungen mit Begründung, keine Testchronik |
| ROADMAP.md | Priorisierte nächste Arbeit mit Verweisen auf offene IDs |
| TEST_RESULTS.md / docs/evidence/index.json | Menschlicher Nachweisindex / maschinenlesbare Identitäten |
| docs/OPEN_ITEMS.md | Fehler, Datenlücken, Abnahmekriterien und Live-Status |
| docs/ARCHITECTURE.md | Module, Zusammenhänge, Ladefolge und passende Tests |
| docs/archive/ | Klar historische, abgeschlossene Verlaufsnotizen |

## Abschluss und neuer Nachweis

1. Aktuelle Übergabe ersetzen; Status nicht in mehrere Dateien kopieren.
2. Offene IDs mit Beleg aktualisieren. Geplant/implementiert/automatisiert geprüft/live bestätigt
   getrennt halten. Keine Live-Abnahme aus Simulation ableiten.
3. Neue Addonprüfung über Test-CraftDeja.ps1 mit eindeutigem Umfang/Profile ausführen.
   Nach Erfolg Manifest aus METADATEN.json übernehmen, Test-Basiscommit und späteren
   Release-Commit getrennt nennen; ZIP-SHA256 und Ergebnis im Index aktualisieren.
4. Nur getestete Bytes als getestet verzeichnen. Kein neuer geprüfter Hash durch bloßes
   Nachtragen eines geänderten Quellhashs. Neuer Test muss die Änderung abdecken.
5. Git-Diff prüfen; Laufzeit, Grafiken und Build-/Testinputs bei Dokumentationsarbeit unverändert
   lassen. Archivierung erhält Originalbytes mit SHA256-Manifest. Keine Secrets/Spielerdaten sammeln.

## Prüfung dieser Umstrukturierung

Isolierte Entwicklerprüfung, keine WoWLua-/Spielsimulation: PowerShell-Parser, lesender echter
Projektcheck sowie temporäre Minimal-Fixtures für geänderte/neue/fehlende Quellen/Tests,
fehlende/falsche Berichte, Versionswechsel und ungültige Manifestpfade.
Protokoll, Umfang und ZIP werden lokal unter reports/context/ erzeugt. Kein automatischer Upload.
Ausgeführt am 17.11.2026: **17 bestanden, 0 fehlgeschlagen**;
reports/context/20261117-065337-dbaf75.zip. Versionierter technischer Nachweis:
docs/evidence/context-check.json (Werkzeug-/Harnesshashes, Prüfumfang und Berichtshash).
Bestehende Addonfreigabe gilt nur bei weiterhin passenden Originalhashes; keine neue Vollsuite
für reine Dokumentation behaupten. Reproduktion: tools/Test-ProjectContext.ps1.
