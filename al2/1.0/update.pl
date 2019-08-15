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

die "php version is required" unless $php_version;
die "node verison is reqiored" unless $node_version;

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

sub execute_template {
    my ($name) = @_;
    open my $fh, '<', "template/$name" or die $!;
    my $doc = do { local $/ = undef; <$fh>; };
    close $fh;

    $doc =~ s/%%PHP_VERSION%%/$php->{version}/;
    $doc =~ s/%%PHP_SHA256%%/$php->{sha256}/;
    $doc =~ s/%%PHP_GPG_KEYS%%/$php->{gpg}/;
    $doc =~ s/%%NODE_VERSION%%/$node->{version}/;

    mkdir "php$php_version" unless -d "php$php_version";
    mkdir "php$php_version/node$node_version" unless -d "php$php_version/node$node_version";

    my $dir = "php$php_version/node$node_version";
    open $fh, '>', "$dir/$name" or die $!;
    print $fh $doc;
    close $fh;

    chmod 0755, "$dir/$name" if -x "template/$name";
}

execute_template 'Dockerfile';
execute_template 'ssh_config';
execute_template 'dockerd-entrypoint.sh';
execute_template 'runtimes.yml';

__END__

usage:
    update.sh $PHP_MINOR_VERSION $NODE_MAJOR_VERSION
    update.sh 7.3 10