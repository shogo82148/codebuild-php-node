#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use JSON qw(decode_json encode_json);

my $php_gpg_keys = {
    # https://wiki.php.net/todo/php73
    # cmb & stas
    # https://secure.php.net/gpg-keys.php#gpg-7.3
    "7.3" => ["CBAF69F173A0FEA4B537F470D66C9593118BCCB6", "F38252826ACD957EF380D39F2F7956BC5DA04B5D"],

    # https://wiki.php.net/todo/php72
    # pollita & remi
    # https://secure.php.net/downloads.php#gpg-7.2
    # https://secure.php.net/gpg-keys.php#gpg-7.2
    "7.2" => ["1729F83938DA44E27BA0F4D3DBDB397470D12172", "B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F"],

    # https://wiki.php.net/todo/php71
    # davey & krakjoe
    # pollita for 7.1.13 for some reason
    # https://secure.php.net/downloads.php#gpg-7.1
    # https://secure.php.net/gpg-keys.php#gpg-7.1
    "7.1" => ["A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0", "528995BFEDFBA7191D46839EF9BA0ADA31CBD89E", "1729F83938DA44E27BA0F4D3DBDB397470D12172"],
};
# see https://secure.php.net/downloads.php

my ($php_version, $node_version) = @ARGV;

my $php = do {
    my ($major, $minor) = split /[.]/, $php_version;
    my $json = decode_json(`curl -sSL "https://secure.php.net/releases/index.php?json&max=100&version=$major"`);
    my @versions = (sort {
        my @a = split /[.]/, $a;
        my @b = split /[.]/, $b;
        return $a[0] <=> $b[0] if $a[0] != $b[0];
        return $a[1] <=> $b[1] if $a[1] != $b[1];
        return $a[2] <=> $b[2] if $a[2] != $b[2];
        return $a[3] cmp $b[3];
    } grep { $_ =~ m(^$php_version[.]) } keys %$json);
    my $latest = pop @versions;
    my $info = (grep { $_->{filename} =~ m([.]tar[.]xz$) } @{$json->{$latest}{source}})[0];
    $info->{version} = $latest;
    $info->{gpg} = join ' ', @{$php_gpg_keys->{"$major.$minor"}};
    $info;
};

my $node_gpg_keys = [
    "94AE36675C464D64BAFA68DD7434390BDBE9B9C5",
    "FD3A5288F042B6850C66B31F09FE44734EB7990E",
    "71DCFD284A79C3B38668286BC97EC7A07EDE3FC1",
    "DD8F2338BAE7501E3DD5AC78C273792F7D83545D",
    "C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8",
    "B9AE9905FFD7803F25714661B63B535A4C206CA9",
    "77984A986EBC2AA786BC0F66B01FBB92821C587A",
    "8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600",
    "4ED778F539E3634C779C87C6D7062848A1AB005C",
    "A48C2BEE680E841632CD4E44F07496B3EB3C1762",
    "B9E2F5981AA6E0CD28160D9FF13993A75599653C",
];

my $node = do {
    my $info = `curl  -sSL --compressed https://nodejs.org/dist/`;
    my @lines = split /\n/, $info;
    print $lines[0];
    @lines = map {
        $_ =~ m(<a\s+href="v($node_version[.][^/"]+)/?") ? $1 : ()
    } @lines;
    my @versions = sort {
        my @a = split /[.]/, $a;
        my @b = split /[.]/, $b;
        return $a[0] <=> $b[0] if $a[0] != $b[0];
        return $a[1] <=> $b[1] if $a[1] != $b[1];
        return $a[2] <=> $b[2];
    } @lines;
    my $latest = pop @versions;
    +{
        version => $latest,
    };
};

my $yarn_gpg_keys = ["6A010C5166006599AA17F08146C2130DFD2497F5"];

my $yarn = do {
    +{
        version => `curl -sSL --compressed https://yarnpkg.com/latest-version`,
    };
};

open my $fh, '<', 'Dockerfile.template' or die $!;
my $doc = do { local $/ = undef; <$fh>; };
close $fh;

$doc =~ s/%%PHP_VERSION%%/$php->{version}/;
$doc =~ s/%%PHP_SHA256%%/$php->{sha256}/;
$doc =~ s/%%PHP_GPG_KEYS%%/$php->{gpg}/;
$doc =~ s/%%NODE_VERSION%%/$node->{version}/;
$doc =~ s/%%NODE_GPG_KEYS%%/@{[join " \\\n     ", @$node_gpg_keys]}/;
$doc =~ s/%%NODE_VERSION%%/$yarn->{version}/;
$doc =~ s/%%YARN_GPG_KEYS%%/@{[join " ", @$yarn_gpg_keys]}/;

open $fh, '>', 'Dockerfile' or die $!;
print $fh $doc;
close $fh;

__END__

usage:
    update.sh $PHP_MINOR_VERSION $NODE_MAJOR_VERSION
    update.sh 7.3 10
