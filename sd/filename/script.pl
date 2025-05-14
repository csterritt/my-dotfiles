#/usr/bin/env perl
while (<>) {
    chomp;
    if (/^\d+(\D.*)$/) {
        $old = $_;
        $first += 1;
        $new = sprintf "%02d%s", $first, $1;
        printf "mv '%s' '%s'\n", $_, $new if ($_ ne $new);
    }
}
