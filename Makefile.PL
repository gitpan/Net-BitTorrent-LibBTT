use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my $apr = `$ENV{APR_CONFIG} --link-ld`;
chomp($apr);

WriteMakefile(
    NAME              => 'Net::BitTorrent::LibBTT',
    VERSION_FROM      => 'lib/Net/BitTorrent/LibBTT.pm', # finds $VERSION
    PREREQ_PM         => { "APR" => 0 }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Net/BitTorrent/LibBTT.pm', # retrieve abstract from module
       AUTHOR         => 'Tyler \'Crackerjack\' MacDonald <faraway@>') : ()),
    LIBS              => ['-ldb-4.2', '-lapr-0'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I. -I.. -I../..' . `$ENV{APR_CONFIG} --includes`, # e.g., '-I. -I/usr/include/other'
    dynamic_lib 		=> { OTHERLDFLAGS	  => "$apr ../libbtt.a" }
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '../libbtt.a $(O_FILES)', # link all the C files too
);
if  (eval {require ExtUtils::Constant; 1}) {
  # If you edit these definitions to change the constants used by this module,
  # you will need to use the generated const-c.inc and const-xs.inc
  # files to replace their "fallback" counterparts before distributing your
  # changes.
  my @names = (qw(BT_EMPTY_HASH BT_EMPTY_INFOHASH BT_EMPTY_PEERID BT_EVENT_LEN
		 BT_HASH_LEN BT_INFOHASH_LEN BT_PATH_LEN BT_PEERID_LEN
		 BT_PEERSTR_LEN BT_SHORT_STRING BT_TINY_STRING HTTP_BAD_REQUEST
		 HTTP_CREATED HTTP_LOCKED HTTP_NOT_FOUND HTTP_OK
		 HTTP_SERVER_ERROR HTTP_UNAUTHORIZED));
  ExtUtils::Constant::WriteConstants(
                                     NAME         => 'Net::BitTorrent::LibBTT',
                                     NAMES        => \@names,
                                     DEFAULT_TYPE => 'IV',
                                     C_FILE       => 'const-c.inc',
                                     XS_FILE      => 'const-xs.inc',
                                  );

}
else {
  use File::Copy;
  use File::Spec;
  foreach my $file ('const-c.inc', 'const-xs.inc') {
    my $fallback = File::Spec->catfile('fallback', $file);
    copy ($fallback, $file) or die "Can't copy $fallback to $file: $!";
  }
}
