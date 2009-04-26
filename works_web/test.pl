#!/usr/bin/perl -w 

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw/:standard/;

print "Content-Type: text/html; charset=utf-8\n\n";

print "<tt><b>Method: $ENV{'REQUEST_METHOD'}</b></tt><br><br>";

$q = new CGI;
$params{$_} = $q->param($_) foreach ($q->param());

print "$_ = $params{$_}<br>\n" foreach (keys %params);

if ($ENV{'REQUEST_METHOD'} eq "POST") {
    print "<hr>\n<tt><b>Parsed POSTDATA:</b></tt><br><br>";

    @parts = split( /\&/, $params{"POSTDATA"} );
    foreach $part (@parts) {
      $part =~ s/\+/ /g;
      ( $name, $value ) = split( /\=/, $part );
      $name =~ s/%(..)/pack("c",hex($1))/ge;
      $value =~ s/%(..)/pack("c",hex($1))/ge;
      # some extra security code needed here
      $np{ "$name" } = $value;
}
    print "$_ = $np{$_}<br>\n" foreach (keys %np);
}

print "<hr>";
print "<pre>";
print "<tt><b>Variables:</b></tt><br><br>";
print "$_ = \t\t$ENV{$_}\n" foreach (keys %ENV);
print "</pre>";
