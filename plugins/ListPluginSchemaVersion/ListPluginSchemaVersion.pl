package MT::Plugin::Admin::OMV::ListPluginSchemaVersion;
# ListPluginSchemaVersion (C) 2012 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU Lesser General Public License, version 3.
# $Id$

use strict;
use warnings;
use MT 4;

use vars qw( $VENDOR $MYNAME $FULLNAME $VERSION );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1]);
(my $revision = '$Rev$') =~ s/\D//g;
$VERSION = 'v0.10'. ($revision ? ".$revision" : '');

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    id => $FULLNAME,
    key => $FULLNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/2012/11301839/', # Blog
    doc_link => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME", # tracWiki
    description => <<'HTMLHEREDOC',
<__trans phrase="Show a list of schema version of all plugins">
HTMLHEREDOC
    l10n_class => "${FULLNAME}::L10N",
    system_config_template => "$VENDOR/$MYNAME/table.tmpl",
});
MT->add_plugin ($plugin);

sub instance { $plugin }

### Override MT::Plugin::config_template
sub config_template {
    my $self = shift;
    my ($param, $scope) = @_;

    my $psv = MT->config('PluginSchemaVersion') || {};
    my @psv;
    foreach (sort keys %$psv) {
        my %data = (
            id => $_,
            name => $_,
            schema_version => $psv->{$_},
            found => 0,
        );
        if (defined (my $c = MT->component ($_))) {
            defined $c->name
                and ($data{name} = $c->name);
            defined $c->version
                and ($data{version} = $c->version);
            defined $c->schema_version
                and ($data{schema_version} = $c->schema_version);
            $data{found} = 1;
        }
        push @psv, \%data;
    }
    $param->{psv} = \@psv if @psv;

    return $self->SUPER::config_template (@_);
}

1;