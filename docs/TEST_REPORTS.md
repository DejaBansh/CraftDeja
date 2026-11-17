# Testberichte / test reports

Ab dieser Runde werden Windows-Tests ueber den Berichtsbefehl ausgefuehrt:

```powershell
.\tools\Test-CraftDeja.ps1 -Profile release -OpenReportFolder
```

Dieser Befehl baut zuerst das Addon und startet anschliessend die komplette Testsuite. Fuer ein gezieltes Paket:

```powershell
.\tools\Test-CraftDeja.ps1 -Profile release -Filter @('NetCostSuite','EconomyEvidenceSuite') -OpenReportFolder
```

`-SkipBuild` ist nur fuer bewusst begrenzte Wiederholungstests vorgesehen. Umfang und ausgelassener Build werden im Bericht vermerkt. Der Exitcode bleibt bei fehlgeschlagenen Tests, Build-/Startfehlern oder fehlender Testzusammenfassung ungleich null. Uebersprungene Tests werden sichtbar ausgewiesen und nicht als bestanden gezaehlt.

## Ergebnis teilen

Jeder Lauf erzeugt `reports/tests/ZEITSTEMPEL-ID.zip` mit:

- `BERICHT.md`: Ergebnis, Version, Git-Stand, Umfang, Zeiten und Zusammenfassung.
- `PROTOKOLL.txt`: vollstaendige Ausgabe einschliesslich Warnungen/Fehlern, STDOUT und STDERR getrennt je Prozess.
- `METADATEN.json`: maschinenlesbare Zaehler, Exitcode, Buildstatus, Konfiguration und Quellhashes.

Auch ein fehlgeschlagener Lauf wird verpackt. `reports/tests/LETZTER_BERICHT.txt` nennt den neuesten ZIP-Pfad. Mit `-OpenReportFolder` wird die ZIP im Windows-Explorer markiert.

**Zum Teilen die ZIP anhaengen** oder einen freigegebenen Downloadlink verwenden. Ein lokaler Pfad ist kein oeffentlicher Link. In einer Sitzung mit freigegebenem Zugriff auf denselben Rechner koennen lokale Berichte direkt gelesen werden; andere Rechner oder Chats ohne diesen Zugriff brauchen die Datei. Es gibt keinen automatischen oeffentlichen Upload.

Der versionierte Einstieg ist [evidence/index.json](evidence/index.json). Er nennt Ergebnis, Release- und Test-Basiscommit, Manifest und Berichtshash. Lokale reports/-Dateien fehlen in frischen Checkouts; Get-ProjectContext.ps1 meldet das getrennt von passenden Quellhashes. Ein neuer HEAD mit reinen Dokumentationsaenderungen macht gleiche getestete Laufzeitbytes nicht automatisch ungueltig. Neue/geaenderte Quellen oder Tests schon. Das Manifest deckt nur den angegebenen Umfang ab, nicht pauschal Grafiken oder Liveverhalten.

Berichte sind durch `.gitignore` vom normalen Git-Commit ausgeschlossen. Ein erfolgreicher Bericht ist keine automatische Freigabe oder Liveserverpruefung. Projektfremde Dateien werden nicht gesammelt.

## English

Run `tools/Test-CraftDeja.ps1 -Profile release` for a release build plus complete test run; optional `-Filter` selects suites and `-OpenReportFolder` selects the ZIP in Windows Explorer. Every attempt produces a report ZIP under `reports/tests`, including failures and startup errors after a valid project path has been resolved. The ZIP contains the summary, full native output and metadata. A skipped build and test scope remain explicit.

Attach the ZIP or share an accessible URL for other machines/sessions. A session with authorized access to the same filesystem can read local reports; a local path is not a public link. Reports are not automatically published or committed. Native stdout/stderr are drained asynchronously; their relative chronological order is not reconstructed.
