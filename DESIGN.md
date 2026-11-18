# DESIGN.md — shae-perl-log-analyzer

Design system applied per the SHAE field manual (`shared/design-system.md`).
This CLI has no UI layer, so the design system is expressed in its command
contract, report layout, and documentation rather than pixels.

## Core principles

### Precise over decorative
The report is aligned, mono-spaced data with no ornamental noise. Every section
has a hairline rule separator and labeled columns (IP, Requests, Share;
Endpoint, Hits, Share; Status, Count, Share; Hour, Requests, Heat). Numbers
are right-aligned for easy comparison.

### Flat and physical
No spinners, no colour-coded severity badges, no progress bars. The tool reads
a file, aggregates in memory, and prints a static report. Deterministic and
physical: malformed lines are skipped without fanfare.

### Type does the work
Section headings are short, direct labels ("Top IPs", "Top endpoints",
"Status code distribution", "Bytes transferred", "Requests per hour heatmap").
Percentages let share do the comparative work; the hour heatmap uses a text bar
("#") scaled to the maximum hour so volume is readable at a glance.

### Confident restraint
One signal colour (oxide #B341B conceptually) marks the usage error printed to
stderr when no log path is supplied. All other output is neutral ink on paper.

## Accessibility

- Complete keyboard path: log path passed as an argument.
- Output is plain text; no colour-only information.
- Non-zero exit code and stderr message on missing/unreadable log file.

## Motion

Not applicable to a CLI report. If a future TUI is added, state changes will
use 140–240ms and reduced-motion fallbacks.

## Files

- `src/analyzer.pl` — Perl 5 log parser and report printer.
- `scripts/install.sh` — symlinks to `~/.local/bin/shae-log-analyzer`.
- `Makefile` — `make test` builds a sample log and prints the report.
- `docs/DE.md`, `docs/ES.md` — localized install guides.
