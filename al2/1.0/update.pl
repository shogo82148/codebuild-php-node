#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use JSON qw(decode_json encode_json);
use version 0.77;

sub curl {
    my $url = shift;
    my $cnt = 0;
    my $sleep = 1;
RETRY:
    my $ret = `curl -sSL --compressed "$url"`;
    if ($?) {
        $cnt++;
        if ($cnt > 10) {
            die "fail to get $url";
        }
        print STDERR "fail to get $url...\n";

        sleep $sleep;
        $sleep *= 2;
        if ($sleep > 30) {
            $sleep = 30;
        }
        print STDERR "retry\n";
        goto RETRY;
    }
    return $ret;
}

my ($php_version, $node_version) = @ARGV;

die "php version is required" unless $php_version;
die "node verison is reqiored" unless $node_version;

my $php = do {
    my ($major, $minor) = split /[.]/, $php_version;
    my $json = decode_json(curl("https://www.php.net/releases/index.php?json&max=100&version=$major"));
    my @versions = (sort {
        version->parse("v$a") <=> version->parse($b);
    } grep { $_ =~ m(^$php_version[.]) } keys %$json);
    my $latest = pop @versions;
    my $info = (grep { $_->{filename} =~ m([.]tar[.]xz$) } @{$json->{$latest}{source}})[0];
    $info->{version} = $latest;
    $info;
};

my $node = do {
    my $info = curl("https://nodejs.org/dist/");
    my @lines = split /\n/, $info;
    @lines = map {
        $_ =~ m(<a\s+href="v($node_version[.][^/"]+)/?") ? $1 : ()
    } @lines;
    my @versions = sort {
        version->parse("v$a") <=> version->parse($b);
    } @lines;
    my $latest = pop @versions;
    +{
        version => $latest,
    };
};

sub execute_template {
    my ($name) = @_;
    open my $fh, '<', "template/$name" or die "fail to open template/$name: $!";
    my $doc = do { local $/ = undef; <$fh>; };
    close $fh;

    $doc =~ s/%%PHP_MINOR_VERSION%%/$php_version/g;
    $doc =~ s/%%PHP_VERSION%%/$php->{version}/g;
    $doc =~ s/%%PHP_SHA256%%/$php->{sha256}/g;
    $doc =~ s/%%NODE_MAJOR_VERSION%%/$node_version/g;
    $doc =~ s/%%NODE_VERSION%%/$node->{version}/g;

    my $dir = "php$php_version/node$node_version";
    open $fh, '>', "$dir/$name" or die $!;
    print $fh $doc;
    close $fh;

    chmod 0755, "$dir/$name" if -x "template/$name";
}

system("rm", "-rf", "php$php_version/node$node_version");
system("mkdir", "-p", "php$php_version/node$node_version");

execute_template 'Dockerfile';
execute_template 'ssh_config';
execute_template 'dockerd-entrypoint.sh';
execute_template 'runtimes.yml';
system("mkdir", "-p", "php$php_version/node$node_version/tools/runtime_configs/python");
execute_template 'tools/runtime_configs/python/3.7.10';
system("mkdir", "-p", "php$php_version/node$node_version/tools/runtime_configs/php");
execute_template "tools/runtime_configs/php/$php_version";

__END__

usage:
    update.sh $PHP_MINOR_VERSION $NODE_MAJOR_VERSION
    update.sh 7.3 10
