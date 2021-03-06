use DBI;
use Data::Dumper;
use Config::Simple;
my $dbh;
my $sth;
my %mysql_types = (
    "tinyint"            => 127,
    "tinyint unsigned"   => 255,
    "int"                => 2147483647,
    "int unsigned"       => 4294967295,
    "bigint unsigned"    => 18446744073709551615,
    "bigint"             => 9223372036854775807,
    "smallint unsigned"  => 65535,
    "smallint"           => 32767,
    "mediumint"          => 8388607,
    "mediumint unsigned" => 1677215,

);

my $config = shift;

#$config="user_data.cfg"  if(!definded($config));
my $cfg      = new Config::Simple($config);
my $database = $cfg->param("database");
my $host     = $cfg->param("host");
my $user     = $cfg->param("user");
my $password = $cfg->param("password");

sub capture_mysql_type {

    my $type = shift;
    @array = split( /\([0-9]+?\)/, $type );
    my $final_type = "";
    foreach (@array) {
        $final_type = $final_type . $_;
    }

    return $final_type;
}

sub desc_table {
    my $table = shift;
    print "my table===" . $table . "\n";
    my $sth = $dbh->prepare("desc  $table   ");
    $sth->execute();
    my $ref  = $sth->fetchrow_hashref();
    my $type = $ref->{'Type'};
    if ( $type !~ /char/ ) {
        print "=====================================================\n";
        my $increment     = $ref->{'Field'};
        my $obtained_type = capture_mysql_type( $ref->{'Type'} );
        print "type is==" . $obtained_type . "\n";
        return if ( $obtained_type eq "timestamp" );
        print
"Table NAme= $table has key $ref->{'Field'} and type $obtained_type   \n";
        my $sth =
          $dbh->prepare("select max($increment)  as max_id from  $table   ");
        $sth->execute();
        my $ref = $sth->fetchrow_hashref();
        $max_id = $ref->{'max_id'};
        print "max_id is $max_id \n";

        if ( defined( $mysql_types{$obtained_type} ) ) {

            print "==================================================\n";
            print " max size of $obtained_type = " . $mysql_types{$obtained_type} . "\n";
            print " column  contains  " . $max_id . " rows \n";
            $size = $mysql_types{$obtained_type} - $max_id . "\n";
            print "Difference between size of $obtained_type - table rows  =" . $size . "\n";
            my $percent_size = $max_id / $mysql_types{$obtained_type};
            print "percent size captured ($obtained_type/rows)" . $percent_size . "\n";
            print "Overload it!!!!!===" if ( $percent_size > 0.85 );
            print "==================================================\n";
        }
        else {
            print "Type is undefined!!!!!!!!!!!!!!\n";
        }
        print "=====================================================\n";

        print "\n";
        print "\n";
    }

    print "Show create table=======================\n";

    print "End=======================\n";
}
$dbh = DBI->connect( "DBI:mysql:database=$database;host=$host",
    $user, $password, { RaiseError => 1 } );
$sth = $dbh->prepare("show tables");

$sth->execute();
while ( my $ref = $sth->fetchrow_hashref() ) {
    print "Found a tables " . $ref->{"Tables_in_$database"} . "\n";
    desc_table( $ref->{"Tables_in_$database"} );
}

