# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-BitTorrent-LibBTT.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More tests => 2;
BEGIN { use_ok('Net::BitTorrent::LibBTT') };


my $fail = 0;
foreach my $constname (qw(
	BT_EMPTY_HASH BT_EMPTY_INFOHASH BT_EMPTY_PEERID BT_EVENT_LEN
	BT_HASH_LEN BT_INFOHASH_LEN BT_PATH_LEN BT_PEERID_LEN BT_PEERSTR_LEN
	BT_SHORT_STRING BT_TINY_STRING HTTP_BAD_REQUEST HTTP_CREATED
	HTTP_LOCKED HTTP_NOT_FOUND HTTP_OK HTTP_SERVER_ERROR HTTP_UNAUTHORIZED)) {
  next if (eval "my \$a = $constname; 1");
  if ($@ =~ /^Your vendor has not defined Net::BitTorrent::LibBTT macro $constname/) {
    print "# pass: $@";
  } else {
    print "# fail: $@";
    $fail = 1;
  }

}

ok( $fail == 0 , 'Constants' );
#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

