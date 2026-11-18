#!/usr/bin/env perl
#
# shae-perl-log-analyzer — src/analyzer.pl
#
# Reads Apache/nginx-style combined access logs and prints a formatted report:
#   * top IPs by request count
#   * top endpoints by hits
#   * status code distribution (200 / 404 / 500 ...)
#   * bytes transferred total
#   * requests per hour heatmap
#
# Usage: perl src/analyzer.pl <access.log>
#
# Written in idiomatic Perl 5. No non-core dependencies.

use strict;
use warnings;

my $logfile = shift @ARGV
    or die "Usage: $0 <access.log>\n";

open(my $fh, '<', $logfile)
    or die "Cannot open '$logfile': $!\n";

# Combined log format:
# 192.168.1.1 - - [10/Oct/2023:13:55:36 +0000] "GET /index.html HTTP/1.1" 200 1234 "-" "UA"
my $log_re = qr{
    ^ (\S+)                      # client IP
    \s+ \S+ \s+ \S+              # ident authuser (ignored)
    \s+ \[ ([^\]]+) \]           # timestamp
    \s+ " (\S+) \s+ (\S+) \s+ [^"]*"   # request: method path protocol
    \s+ (\d{3})                  # status code
    \s+ (\d+|-)                  # bytes sent
}x;

my %ip_count;
my %endpoint_count;
my %status_count;
my %hour_count;
my $total_requests = 0;
my $total_bytes    = 0;

while (my $line = <$fh>) {
    chomp $line;
    next unless length $line;
    next unless $line =~ $log_re;

    my ($ip, $ts, $method, $path, $status, $bytes) = ($1, $2, $3, $4, $5, $6);

    $ip_count{$ip}++;
    $endpoint_count{$path}++;
    $status_count{$status}++;
    $total_bytes += $bytes if $bytes =~ /^\d+$/;

    # Extract HH from timestamp: 10/Oct/2023:13:55:36 +0000
    # Anchor to the 4-digit year so we do not match inside "2023:13:05:12".
    if ($ts =~ /(\d{4}):(\d{2}):(\d{2}):(\d{2})/) {
        $hour_count{$2}++;
    }

    $total_requests++;
}

close($fh);

# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------
print "SHAE Log Analyzer Report\n";
print "=" x 56, "\n";
printf "Log file   : %s\n", $logfile;
printf "Total requests: %d\n", $total_requests;
printf "Total bytes transferred : %d\n", $total_bytes;
print "\n";

# Top IPs by request count
print "Top IPs by request count\n";
print "-" x 56, "\n";
printf "%-18s %10s  %s\n", "IP", "Requests", "Share";
my $top_ips = 0;
for my $ip (sort { $ip_count{$b} <=> $ip_count{$a} } keys %ip_count) {
    my $share = $total_requests ? sprintf("%.1f%%", 100 * $ip_count{$ip} / $total_requests) : "0.0%";
    printf "%-18s %10d  %s\n", $ip, $ip_count{$ip}, $share;
    $top_ips++;
    last if $top_ips >= 10;
}
print "\n";

# Top endpoints by hits
print "Top endpoints by hits\n";
print "-" x 56, "\n";
printf "%-40s %10s  %s\n", "Endpoint", "Hits", "Share";
my $top_eps = 0;
for my $ep (sort { $endpoint_count{$b} <=> $endpoint_count{$a} } keys %endpoint_count) {
    my $share = $total_requests ? sprintf("%.1f%%", 100 * $endpoint_count{$ep} / $total_requests) : "0.0%";
    printf "%-40s %10d  %s\n", $ep, $endpoint_count{$ep}, $share;
    $top_eps++;
    last if $top_eps >= 10;
}
print "\n";

# Status code distribution
print "Status code distribution\n";
print "-" x 56, "\n";
printf "%-10s %10s  %s\n", "Status", "Count", "Share";
for my $code (sort { $a <=> $b } keys %status_count) {
    my $share = $total_requests ? sprintf("%.1f%%", 100 * $status_count{$code} / $total_requests) : "0.0%";
    printf "%-10s %10d  %s\n", $code, $status_count{$code}, $share;
}
print "\n";

# Bytes transferred total
print "Bytes transferred\n";
print "-" x 56, "\n";
printf "%-10s %15s\n", "Total", $total_bytes;
print "\n";

# Requests per hour heatmap
print "Requests per hour heatmap\n";
print "-" x 56, "\n";
printf "%-6s %10s  %s\n", "Hour", "Requests", "Heat";

my $max_hour_count = 0;
for my $h (0 .. 23) {
    my $c = $hour_count{$h} // 0;
    $max_hour_count = $c if $c > $max_hour_count;
}

for my $h (0 .. 23) {
    my $c = $hour_count{$h} // 0;
    my $bar = "";
    if ($max_hour_count > 0) {
        my $len = int(($c / $max_hour_count) * 30) || ($c > 0 ? 1 : 0);
        $bar = "#" x $len;
    }
    printf "%02d:00  %10d  %s\n", $h, $c, $bar;
}
print "\n";

print "End of report\n";
