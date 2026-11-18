# shae-perl-log-analyzer (de)

Ein dependencyfreies Perl-CLI, das Apache/nginx-Zugriffslogs im Combined-Format
parst und einen formatierten Bericht ausgieht: Top-IPs, Top-Endpunkte,
Statuscode-Verteilung, insgesamt übertragene Bytes und ein
Requests-pro-Stunde-Heatmap.

## Installation

```bash
git clone https://github.com/spdedsec/shae-perl-log-analyzer.git
cd shae-perl-log-analyzer
bash scripts/install.sh
```

Dadurch wird `src/analyzer.pl` als `~/.local/bin/shae-log-analyzer` verlinkt.
Stelle sicher, dass `~/.local/bin` in deinem `PATH` liegt.

## Verwendung

```bash
shae-log-analyzer /var/log/apache2/access.log
shae-log-analyzer access.log | head -n 80
```

## Testen

```bash
make test
```

Erstellt eine Beispiel-Zugriffslog-Datei in `/tmp/shae-access.log` und gibt
den Bericht aus.

## Anforderungen

- Perl 5 (nur Core-Module, keine CPAN-Abhängigkeiten)

## Lizenz

MIT
