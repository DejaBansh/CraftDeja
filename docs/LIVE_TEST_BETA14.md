# Beta.14 — vorbereitete Installation und kurzer Mot-Live-Test

Vorbereitet am 15.11.2026, **nicht ausgeführt**. Automatisierte Prüfung bestanden;
Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen.

## Geprüfte Ausgangslage

- Branch `feature/acquisition-costs`, Trainerfix-Commit `014381f3cc8c5197e3e268b1a35c7418a371cc8f`.
- `reports/tests/20261115-140332-96c718.zip`: beta.14, wowlua 0.13.14,
  Build erfolgreich, 485 bestanden, 0 fehlgeschlagen, 0 übersprungen, 204.91s.
- Alle 18 aufgezeichneten Quellprüfsummen stimmen beim Abschluss erneut exakt.
  Code, Tests, Manifest und Testskript sind gegenüber dem Trainerfix unverändert.
- Vorhandenes Projektskript: `tools/Test-CraftDeja.ps1`; kein eigenes
  Installationsskript im Projekt. `wowlua --help` und `wowlua install --help`
  bestätigen `install`, `--flavor`, `--client`, `--wow` und `--force`.

## Nächster Installationsschritt — erst nach eigenem Auftrag ausführen

WoW zuvor vollständig beenden. PowerShell benötigt Schreibrechte für den
angegebenen AddOns-Ordner. Diese Befehle sichern zuerst die bestehende Installation
lokal und installieren anschließend einmalig den Dev-Build ausschließlich nach
`C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftDeja`.
`--force` erlaubt den Ersatz einer bestehenden, nicht von wowlua verwalteten
Addoninstallation; deshalb muss das Backup davor erfolgreich sein.

```powershell
Set-Location -LiteralPath 'C:\Users\Tim\Projects\CraftDeja'
$ErrorActionPreference = 'Stop'
$wowluaExe = Join-Path $env:USERPROFILE '.wowlua\bin\wowlua.exe'
$wowRoot = 'C:\Program Files (x86)\World of Warcraft'
$addonPath = Join-Path $wowRoot '_forever_\Interface\AddOns\CraftDeja'
$backupRoot = Join-Path $PWD 'reports\install'
New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
$backupZip = Join-Path $backupRoot ('CraftDeja-before-beta14-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.zip')
if (-not (Test-Path -LiteralPath $addonPath -PathType Container)) {
    throw 'Erwartete vorhandene CraftDeja-Installation fehlt; Ziel zuerst prüfen.'
}
Compress-Archive -LiteralPath $addonPath -DestinationPath $backupZip -ErrorAction Stop
Write-Host "Backup: $backupZip"
& $wowluaExe install --flavor camelot --client _forever_ --wow $wowRoot --force --color never
if ($LASTEXITCODE -ne 0) { throw 'Installation fehlgeschlagen; nicht als installiert melden.' }
```

Das ist kein Release-/Publish-Befehl und kein laufender `dev`-Watcher. Nicht die
Root-TOC oder den Quellbaum manuell ins Spiel kopieren. Das Backup bleibt lokal
unter `reports/install/` und wird nicht veröffentlicht.

Falls vor der tatsächlichen Installation relevante Dateien geändert wurden,
zunächst den passenden vollständigen Testlauf mit dem vorhandenen Reporter
ausführen; nur bei erfolgreichem Ergebnis fortfahren:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\Test-CraftDeja.ps1
if ($LASTEXITCODE -ne 0) { throw 'Tests fehlgeschlagen; nicht installieren.' }
```

## Kurzer Live-Test nach erfolgreicher Installation

1. WoW starten und mit `/cdj version` beta.14 bestätigen.
2. Bei Mot Dawnstrider das Trainerfenster öffnen. Das Angebot für Rezept 7771
   (Rezeptgegenstand 6345) muss im aktuellen Angebot sichtbar sein; es muss
   nicht gekauft oder gelernt werden. Ist es auf diesem Charakter nicht mehr
   vorhanden, bleibt die Gebührenprüfung offen.
3. CraftDeja-Rezeptdetails aufrufen und die erfasste einmalige Trainergebühr
   mit der tatsächlichen aktuellen Anzeige vergleichen. Für den gemeldeten
   Fall sind 200 Kupfer = 2 Silber erwartet. Ein vorhandener Rezeptgegenstand
   oder günstigerer Rezeptitem-Preis kann die wirtschaftliche Quote beeinflussen;
   eine abweichende Gesamtquote allein beweist keine falsche Trainergebühr.
4. Zusätzlich den tatsächlich gespeicherten Trainerbeleg lesend ausgeben:

   ```text
   /run local r=CraftDeja.character.learningCosts and CraftDeja.character.learningCosts[7771]; print("7771 fee/source/at/now",r and r.cost,r and r.source,r and r.at,time())
   ```

   Erwartet: aktueller Betrag (im gemeldeten Fall 200), Herkunft `trainer` und
   ein Zeitstempel der gerade erfolgten Beobachtung. Ein alter Eintrag allein
   bestätigt die aktuelle Erfassung nicht. Im `/cdj log` die Beobachtung prüfen
   und Details/Traineranzeige dokumentieren.
   Fehlen NPC-GUID, exakter Name/Rang oder Eindeutigkeit, darf kein neuer
   Gebührenbeleg entstehen. Kein Erfolg allein aus dem Öffnen des Trainerfensters ableiten.

Erst die tatsächliche Erfassung für Rezept 7771 bestätigt den Live-Test.
Bis dahin lautet der Status: **automatisierte Prüfung bestanden, Live-Prüfung
der Lerngebühr bei Mot Dawnstrider noch offen**.
