# shae-perl-log-analyzer (es)

Una CLI de Perl sin dependencias que analiza logs de acceso Apache/nginx en
formato combinado e imprime un informe formateado: IPs principales, endpoints
principales, distribución de códigos de estado, total de bytes transferidos y
un heatmap de solicitudes por hora.

## Instalación

```bash
git clone https://github.com/spdedsec/shae-perl-log-analyzer.git
cd shae-perl-log-analyzer
bash scripts/install.sh
```

Esto crea un symlink de `src/analyzer.pl` a `~/.local/bin/shae-log-analyzer`.
Asegúrese de que `~/.local/bin` esté en su `PATH`.

## Uso

```bash
shae-log-analyzer /var/log/apache2/access.log
shae-log-analyzer access.log | head -n 80
```

## Pruebas

```bash
make test
```

Genera un log de acceso de ejemplo en `/tmp/shae-access.log` e imprime el
informe.

## Requisitos

- Perl 5 (solo módulos core, sin dependencias CPAN)

## Licencia

MIT
