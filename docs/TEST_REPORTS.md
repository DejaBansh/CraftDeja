# Testberichte / test reports

Ab dieser Runde werden Windows-Tests ueber den Berichtsbefehl ausgefuehrt:

```powershell
.\tools\Test-CraftDeja.ps1 -OpenReportFolder
```

Dieser Befehl baut zuerst das Addon und startet anschliessend die komplette Testsuite. Fuer ein gezieltes Paket:

```powershell
.\tools\Test-CraftDeja.ps1 -Filter @('NetCostSuite','EconomyEvidenceSuite') -OpenReportFolder
```

`-SkipBuild` ist nur fuer bewusst begrenzte Wiederholungstests vorgesehen. Umfang und ausgelassener Build werden im Bericht vermerkt. Der Exitcode bleibt bei fehlgeschlagenen Tests, Build-/Startfehlern oder fehlender Testzusammenfassung ungleich null. Uebersprungene Tests werden sichtbar ausgewiesen und nicht als bestanden gezaehlt.

## Ergebnis teilen

Jeder Lauf erzeugt `reports/tests/ZEITSTEMPEL-ID.zip` mit:

- `BERICHT.md`: Ergebnis, Version, Git-Stand, Umfang, Zeiten und Zusammenfassung.
- `PROTOKOLL.txt`: vollstaendige Ausgabe einschliesslich Warnungen/Fehlern, STDOUT und STDERR getrennt je Prozess.
- `METADATEN.json`: maschinenlesbare Zaehler, Exitcode, Buildstatus, Konfiguration und Quellhashes.

Auch ein fehlgeschlagener Lauf wird verpackt. `reports/tests/LETZTER_BERICHT.txt` nennt den neuesten ZIP-Pfad. Mit `-OpenReportFolder` wird die ZIP im Windows-Explorer markiert.

**Diese ZIP hier im Chat anhaengen.** Alternativ kann ein bereits von dir freigegebener Downloadlink geteilt werden. Ein lokaler `C:\...`-Pfad ist fuer andere Rechner und diesen Chat nicht erreichbar. Es gibt keinen automatischen oeffentlichen Upload.

Berichte sind durch `.gitignore` vom normalen Git-Commit ausgeschlossen. Ein erfolgreicher Bericht ist keine automatische Freigabe oder Liveserverpruefung. Projektfremde Dateien werden nicht gesammelt.

## English

Run `tools/Test-CraftDeja.ps1` for a build plus complete test run; optional `-Filter` selects suites and `-OpenReportFolder` selects the ZIP in Windows Explorer. Every attempt produces a report ZIP under `reports/tests`, including failures and startup errors after a valid project path has been resolved. The ZIP contains the summary, full native output and metadata. A skipped build and test scope remain explicit.

Attach the ZIP in chat or share a download URL you have made accessible. Local paths are not shareable links. Reports are not automatically published or committed. Native stdout/stderr are drained asynchronously; their relative chronological order is not reconstructed.
