# shae-perl-log-analyzer

A dependency-free Perl CLI that parses Apache/nginx-style combined access logs
and prints a formatted report: top IPs, top endpoints, status code distribution,
total bytes transferred, and a requests-per-hour heatmap.

Part of the SHAE Tier 2 series. Built per the SHAE field manual design system:
precise over decorative, flat and physical, type does the work.

## Install

```bash
git clone https://github.com/spdedsec/shae-perl-log-analyzer.git
cd shae-perl-log-analyzer
bash scripts/install.sh
```

This symlinks `src/analyzer.pl` to `~/.local/bin/shae-log-analyzer`. Make sure
`~/.local/bin` is on your `PATH`.

## Usage

```bash
shae-log-analyzer /var/log/apache2/access.log
shae-log-analyzer access.log | head -n 80
```

## Report sections

| Section | Meaning |
|---------|---------|
| Top IPs | Top 10 client IPs by request count, with share |
| Top endpoints | Top 10 requested paths by hits, with share |
| Status code distribution | HTTP status codes (200, 404, 500, …) with counts and share |
| Bytes transferred | Total bytes served |
| Requests per hour heatmap | Hour 00–23 with request count and a text heat bar |

Malformed lines are silently skipped.

## Test locally

```bash
make test
```

Generates a sample access log in `/tmp/shae-access.log` and prints the report.

## Requirements

- Perl 5 (core modules only, no CPAN dependencies)

## License

MIT
