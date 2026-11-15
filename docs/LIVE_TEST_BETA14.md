# Beta.14 — bestätigte Installation und kurzer Mot-Live-Test

Vorbereitet und auf ausdrücklichen Nutzerauftrag am 15.11.2026 **installiert und geprüft**. Automatisierte Prüfung bestanden;
Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen.

## Installation bestätigt — 15.11.2026

- Auf ausdrücklichen Nutzerauftrag installiert; WoW vor und nach der Installation beendet. WowUp-CF als Addonmanager von Spielprozessen unterschieden; kein Spiel gestartet oder beendet.
- Quellstand: 1186209b0f3caa66265d627a1aee4aa9db6b5f78 auf feature/acquisition-costs. Installierte TOC: 3.9.0-beta.14-dev+1186209; app.release: 3.9.0-beta.14.
- Backup reports/install/beta14-20261115-150654/CraftDeja-before-beta14.zip: alle 116 ursprünglichen Dateien per SHA256 im Archiv geprüft. Ursprünglicher Testbuild zusätzlich separat gesichert.
- Dokumentierter wowlua-install-Befehl erfolgreich (Exit 0), ausschließlich _forever_/Interface/AddOns/CraftDeja. Alle 116 Payload-Dateien bytegenau identisch mit neuem Build; zusätzliche .wowlua-install ist die geprüfte wowlua-Verwaltungsdatei.
- Gegen den gesicherten Testbuild unterscheiden sich nur generierte Commit-/Buildkennungen in CraftDeja.toc und wowlua/runtime.lua. Nach Entfernen genau dieser Metadatenzeilen ebenfalls identisch. Code und Assets unverändert; alle 18 Quellprüfsummen aus dem 485/0/0-Windowsbericht stimmen weiterhin.
- Automatischer teilbarer Installationsbericht: reports/install/beta14-20261115-150654-bericht.zip (Bericht, vollständiges Protokoll, Metadaten und Dateiprüfsummen). Ergebnis installed_verified. Backup und Berichte bleiben lokal.
- Main unverändert. Kein Merge, kein Release/Upload. Kein neuer Testlauf: unveränderter getesteter Laufzeitcode. Bekannte W1034 bleibt.
- Automatisierte Prüfung und Installation bestanden; Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen. Nächster Schritt: im Spiel beta.14 bestätigen, bei Mot das ungelernte Angebot 7771 öffnen und einen frischen learningCosts[7771]-Beleg (200 Kupfer / trainer / aktueller Zeitstempel) prüfen. Nichts kaufen oder lernen erforderlich.

## Geprüfte Ausgangslage

- Branch `feature/acquisition-costs`, Trainerfix-Commit `014381f3cc8c5197e3e268b1a35c7418a371cc8f`.
- `reports/tests/20261115-140332-96c718.zip`: beta.14, wowlua 0.13.14,
  Build erfolgreich, 485 bestanden, 0 fehlgeschlagen, 0 übersprungen, 204.91s.
- Alle 18 aufgezeichneten Quellprüfsummen stimmen beim Abschluss erneut exakt.
  Code, Tests, Manifest und Testskript sind gegenüber dem Trainerfix unverändert.
- Vorhandenes Projektskript: `tools/Test-CraftDeja.ps1`; kein eigenes
  Installationsskript im Projekt. `wowlua --help` und `wowlua install --help`
  bestätigen `install`, `--flavor`, `--client`, `--wow` und `--force`.

## Ausgeführter Installationsschritt — Befehle als Referenz, nicht erneut nötig

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

## Update nach Live-Rückmeldung — beta.15 automatisiert geprüft, noch nicht installiert

Der beobachtete Rückgabewert lautet Name / Status / Icon; beta.14 interpretiert ihn falsch. Korrektur und neue Regressionen für beta.15 siehe docs/ACQUISITION_COSTS.md. Im Spiel bleibt beta.14 installiert; erneute Installation erst separat mit beendetem WoW. Erfolgreiche Live-Erfassung bleibt offen.

Der frühere GetSpellInfo-Diagnosebefehl kann mangels globaler API vor der Ausgabe abbrechen. NPC und moderne Spell-Info lassen sich getrennt davon lesend prüfen:

```text
/run print("NPC",UnitGUID("npc")); local f=C_Spell and C_Spell.GetSpellInfo; local s=f and f(7771); print("7771",s and s.name)
```

Finaler beta.15-Nachweis: reports/tests/20261115-184607-d24132.zip, Build erfolgreich, 505/0/0, 213.08s; 18 Quellhashes exakt geprüft. Der nachgewiesene Name/Status/Icon-Unterschied ist im Code korrigiert; erfolgreiche Live-Erfassung bleibt offen. Bei erneutem Installationsauftrag ein neues Backup erstellen; der alte lokale beta.14-Installationsreporter ist auf Version/Commit beta.14 festgelegt und darf nicht unverändert für beta.15 verwendet werden.

## Mot-Livebeleg bestätigt — 15.11.2026, Screenshot 19:10

- Nutzerbild zeigt `CraftDeja 3.9.0-beta.15` und `7771: 200 trainer 1794766159 1794766291`.
- Damit ist die gespeicherte Lerngebühr für Rezept 7771 (Umhang - Schwacher Schutz, Rezeptgegenstand 6345) mit 200 Kupfer und Herkunft trainer im echten Client belegt. Sie passt zum zuvor ausgegebenen Mot-Angebot `available 135913 200 nil`.
- Beobachtungszeitpunkt 1794766159, Diagnosezeit 1794766291: der Beleg war bei der Abfrage 132 Sekunden alt. Es wird kein neuer Schreibvorgang exakt im Moment der Chatabfrage behauptet.
- Der konkrete Nil-Link-/API-Layout-Fall ist damit live bestätigt. Dies belegt weder alle Trainer/Rezepte noch eine vollständige wirtschaftliche Route oder die Anzeige aller Detailansichten. Das Fehlen von Mot in der separaten Referenzquellenliste wurde hier nicht korrigiert.
- Automatisierter beta.15-Testnachweis bleibt 505/0/0 (213.08s), reports/tests/20261115-184607-d24132.zip; geprüfte Installation: reports/install/beta15-20261115-185829-bericht.zip. Nur Dokumentation/Übergabe geändert, kein neuer Testlauf oder erneute Installation nötig.
- Trainerfix-Quellcommit: 106c61fa7b838096449dec6b18570d82e08a1ee7. Kein Merge nach main und kein Addon-Release. Nächster Schritt: normale Nutzung; weitere konkrete Abweichungen getrennt mit Belegen untersuchen. Für diesen Gebührenbeleg ist kein weiterer Diagnosebefehl nötig.
