package Net::BitTorrent::LibBTT;

use 5.006;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;
use APR;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Net::BitTorrent::LibBTT ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	BT_EMPTY_HASH
	BT_EMPTY_INFOHASH
	BT_EMPTY_PEERID
	BT_EVENT_LEN
	BT_HASH_LEN
	BT_INFOHASH_LEN
	BT_PATH_LEN
	BT_PEERID_LEN
	BT_PEERSTR_LEN
	BT_SHORT_STRING
	BT_TINY_STRING
	HTTP_BAD_REQUEST
	HTTP_CREATED
	HTTP_LOCKED
	HTTP_NOT_FOUND
	HTTP_OK
	HTTP_SERVER_ERROR
	HTTP_UNAUTHORIZED
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	BT_EMPTY_HASH
	BT_EMPTY_INFOHASH
	BT_EMPTY_PEERID
	BT_EVENT_LEN
	BT_HASH_LEN
	BT_INFOHASH_LEN
	BT_PATH_LEN
	BT_PEERID_LEN
	BT_PEERSTR_LEN
	BT_SHORT_STRING
	BT_TINY_STRING
	HTTP_BAD_REQUEST
	HTTP_CREATED
	HTTP_LOCKED
	HTTP_NOT_FOUND
	HTTP_OK
	HTTP_SERVER_ERROR
	HTTP_UNAUTHORIZED
);

our $VERSION = '0.0.8';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Net::BitTorrent::LibBTT::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Net::BitTorrent::LibBTT', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Net::BitTorrent::LibBTT - Manipulate a tracker running under libbtt from perl

=head1 SYNOPSIS

  use Net::BitTorrent::LibBTT;

  my $tracker = Net::BitTorrent::LibBTT->new("/path/to/tracker");
  print "Tracker has ", $tracker->num_peers, " peers.\n";

=head1 DESCRIPTION

  The Net::BitTorrent::LibBTT module provides an interface to the LibBTT
  Hash and Peer databases and the statistics stored in shared memory.

=head1 USAGE

=head2 TRACKER

=head3 $tracker = Net::BitTorrent::LibBTT::Tracker->new($dir, [$master])

  Connects to, or creates, a LibBTT tracker database.
  If "$master" is specified, a new database and shared memory region are created.

  If you are writing a script to be used in the mod_perl environment, use
  the Apache::ModBT module to initialize your tracker object instead; that
  module will connect you to an existing tracker object instead of creating a
  new one, which is far more efficient.

=head3 Net::BitTorrent::LibBTT::Flags()

  Returns an array of key/value pairs for every flag that this
  tracker supports.
  
  The keys returned are the flags' binary values, and the values
  returned are the flags' configuration names.

=head3 $tracker->c

  Returns a Net::BitTorrent::LibBTT::Tracker::Config object which allows
  the tracker's configuration data to be retrieved and set. Consult the
  libbtt documentation for the meanings of each of these configuration
  values.

  Methods:

=over

=item $c->stylesheet([$new_val])

  Gets/sets the URI for the stylesheet to be used on HTML pages generated
  by the tracker.

=item $c->db_dir()

  Returns the directory on the filesystem where the database is kept.

=item $c->flags([$new_val])

  NOTE: It is NOT safe to clear the flags and re-set them the way you want.
  You must always first obtain the current flags, and then only set/clear
  the ones you intend to change. Not all bits in $new_val will have been
  defined by the Flags() function; some are used internally. You can 
  really screw your tracker up if you are not careful when re-setting flags!

=item $c->random_retry([$new_val])

  Gets/sets the number of times "random" operations should be allowed to
  iterate if unsuccessful. Currently, the main "random" operation is picking
  peers off of a peerlist to return to a client; the higher this value, 
  the more times the tracker will retry building peerlists for /announce
  requests if random selection does not return any peers.

=item $c->return_peers([$new_val])

  Gets/sets the default number of peers to return on /announce requests.

=item $c->return_interval([$new_val])

  Gets/sets the base return interval to return to peers on /anounce requests.

=item $c->return_max([$new_val])

  Gets/sets the maximum number of peers to return on /announce requests.

=item $c->return_peer_factor([$new_val])

  Gets/sets the "return peer factor".
  The return interval and return peer factor together determine what interval
  is returned to a peer. For every (factor) peers on any given infohash,
  that infohash's interval is increased. For example, if return_peer_factor
  is set to 10 and return_interval is set to 600, and a hash has 5 peers,
  they will be told to return in 600 seconds. If the hash has 15 peers,
  they would be told to return in 1200 seconds, 21 peers would be 1800
  seconds, etc.

=item $c->hash_watermark([$new_val])

  Gets/sets the hash watermark, which is how many hashes need to be in existance
  before hashes between "hash_min_age" and "hash_max_age" are deleted.

=item $c->hash_min_age([$new_val])

  Gets/sets the minimum inactivity of an infohash before it is eligible for
  deletion.

=item $c->hash_max_age([$new_val])

  Gets/sets the maximum inactivity of an infohash before it must be deleted.

=item $c->parent_server()

  If the LibBTT tracker is embedded inside another server, that server will set this
  value on startup. (eg; "Apache/2.0.49")

=back

=head3 $tracker->s

  Returns a Net::BitTorrent::LibBTT::Stats object which may be used
  to fetch (and set) statistics on the tracker's internal operation.

=over

=item $s->num_children()

  This value is incremented/decremented automatically whenever a
  tracker instance connects/disconnects from a tracker directory
  and should not be modified externally.

=item $s->num_requests([$new_val])

  Gets/sets the total number of requests this tracker has processed.

=item $s->num_hashes([$new_val])

  Gets/sets the number of hashes on this tracker. Setting this value
  is pretty useless, since it is re-set by the tracker frequently to
  reflect the actual database value.

=item $s->num_peers([$new_val])

  Gets/sets the number of peers on this tracker. Setting this value
  is pretty useless, since it is re-set by the tracker frequently to
  reflect the actual database value.

=item $s->announces([$new_val])

  Gets/sets the number of announce requests this tracker has served.

=item $s->scrapes([$new_val])

  Gets/sets the number of scrape requests this tracker has served.

=item $s->full_scrapes([$new_val])

  Gets/sets the number of non-specific scrape requests this tracker has served.

=item $s->bad_announces([$new_val])

  Gets/sets the number of erronious announce requests this tracker has processed.

=item $s->bad_scrapes([$new_val])

  Gets/sets the number of erronious scrape requests this tracker has processed.

=item $s->start_t([$new_val])

  Gets/sets the UNIX timestamp when this tracker started up.

=item $s->master_pid([$new_val])

  Gets/sets process id of the tracker instance that is responsible for final clean-up on shutdown.
  Changing this value can be hazardous!

=item $s->server_time([$new_val])

  This value is updated whenever the tracker processes an announce, register, or scrape request.

=back

=head2 INFOHASHES

=head3 Initialization

=over

=item $hash = $tracker->Infohash($hash_id, [$create])

  Returns a Net::BitTorrent::LibBTT::Infohash object for the given 20-byte $hash_id.
  If $create is set to "1", the hash will be created if it does not already exist.

=item @hashes = $tracker->Infohashes()

  Returns an array of Net::BitTorrent::LibBTT::Infohash objects, one for each hash
  in the tracker's database.

=back

=head3 Methods

=over

=item $hash->save()

  Copy changes to the Net::BitTorrent::LibBTT::Infohash object back into the tracker
  database.
  
  With busy torrents, it is possible that you will overwrite the tracker's updates
  to the infohash with this method. Most of the updates are only statistical and
  vital information is re-populated with each announce request, but if you want to
  keep your statistics accurate, be careful not to take too long between loading
  a hash and saving. If you are doing a long operation on a hash, load it first,
  do your calculations, load it again, update the second object quickly, then save.

  TODO: Hash initializer method that maintains a database cursor on the hash so that
  updates can be made more safely. This brings up issues/complications with the berkeley
  transactional db but should be ready in the next version.

=item $hash->infohash()

  Return the 20-byte infohash value for this torrent. This value may not be modified;
  create a new Infohash object instead.

=item $hash->filename([$new_val])

  Gets/sets the filename to report for this hash on the information page.

=item $hash->filesize([$new_val])

  Gets/sets the size of the actual file(s) represented by this infohash, in bytes.

=item $hash->max_uploaded()

  Returns the highest "uploaded" value returned by any peers currently active on this infohash.

=item $hash->max_downloaded()

  Returns the highest "downloaded" value returned by any peers currently active on this infohash.

=item $hash->max_left()

  Returns the highest "left" value returned by any peers currently active on this infohash.

=item $hash->min_left()

  Returns the lowest "left" value returned by any peers currently active on this infohash,
  except for seeds. (min_left will only ever be "0" if there are only seeds connected).

=item $hash->hits([$new_val])

  Gets/sets the number of times this infohash has been part of an announce request.

=item $hash->peers()

  Returns the number of peers in this hash. If you want to get the peers themselves,
  use the $hash->Peers() method (documented below) instead.

=item $hash->seeds()

  Returns the number of seeds in this hash.

=item $hash->shields()

  Returns the number of shielded seeds in this hash. Shielded seeds are only
  returned to other peers if there are absolutely no other seeds available.

=item $hash->starts([$new_val])

  Gets/sets the number of /announce requests this tracker has processed with
  the "started" attribute set.

=item $hash->stops([$new_val])

  Gets/sets the number of /announce requests this tracker has processed with
  the "stopped" attribute set.

=item $hash->completes([$new_val])

  Gets/sets the number of /announce requests this tracker has processed with
  the "completed" attribute set.

=item $hash->first_t()

  Returns the timestamp for when this hash was first placed in the database.

=item $hash->last_t([$new_val])

  Returns the timestamp for when this hash was last processed.

=item $hash->register_t([$new_val])

  Returns the timestamp for when this hash was "Registered". Hashes with a "register_t" value
  other than 0 will not be deleted by the tracker's garbage collection.

=item $hash->first_peer_t()

  Returns the timestamp for when this hash first had a peer.

=item $hash->last_peer_t()

  Returns the timestamp for when this hash last had a peer.

=item $hash->first_seed_t()

  Returns the timestamp for when this hash first had a seed.

=item $hash->last_seed_t()

  Returns the timestamp for when this hash last had a seed.

=back

=head2 PEERS

  Peers are always returned from Infohashes.

=head3 Functions

=over

=item Net::BitTorrent::LibBTT::Peer::Flags()

  Returns a list of key/value pairs, the keys being valid 
  binary flag values for a peer, the values being the configuration
  names of those flags.

=back

=head3 Initialization

=over

=item $peer = $hash->Peer($peer_id)

  Given the 20-byte peer_id, return a Net::BitTorrent::LibBTT::Peer object from the database
  associated with that peer. If the peer does not exist, it will be created.

=item @peers = $hash->Peers()

  Return all peers associated with a given hash.
  
  NOTE: When dealing with peers, it is ABSOLUTELY VITAL at this point that you do not attempt
  to access Net::BitTorrent::LibBTT::Peer objects after the Infohash object that spawned them
  has been destroyed!!!

=back

=head3 Methods

=over

=item $peer->save()

  Store the object's information in the database. As with infohashes, care should be taken that
  a save() request happens as quickly as possible after the peer object is loaded.

=item $peer->peerid()

  Returns the 20-byte peer id associated with this peer.

=item $peer->infohash()

  Returns the 20-byte infohash associated with this peer.

=item $peer->flags([$new_val])

=item $peer->ua([$new_val])

  Set/return the User-Agent of the peer.

=item $peer->event([$new_val])

=item ($addr, $port) = $peer->address([$new_addr[, $new_port]])

 Get/set the peers's reported IP address and port.
 IP addresses are returned/specified as a 4-byte string in network byte order,
 suitable for passing to inet_ntoa.
 Ports are returned as an integer value in host byte order.

=item ($addr, $port) = $peer->real_address([$new_addr[, $new_port]])

 Get/set the peers's detected IP address and port.

=item $peer->first_t([$new_val])

 Get/set the timestamp for when this peer first connected to the tracker.

=item $peer->last_t([$new_val])

 Get/set the timestamp for when this peer last connected to the tracker.

=item $peer->first_serve_t([$new_val])

 Get/set the timestamp for the first time this peer was served to another peer.

=item $peer->last_serve_t([$new_val])

 Get/set the timestamp for the last time this peer was served to another peer.

=item $peer->complete_t([$new_val])

 Get/set the timestamp for when this peer reported that it was done downloading, if ever.

=item $peer->return_interval([$new_val])

 Get/set the return interval last returned to this peer.

=item $peer->hits([$new_val])

 Get/set the number of times this peer has connected to the tracker.

=item $peer->serves([$new_val])

 Get/set the number of times this peer has been served to other peers.

=item $peer->num_want([$new_val])

 Get/set the number of peers this peer asked for on it's last /announce request.

=item $peer->num_got([$new_val])

 Get/set the number of peers this peer was sent on it's last /announce request.

=item $peer->announce_byes([$new_val])

 Get/set the total number of bytes that have been sent to this peer in /announce responses.

=item $peer->uploaded([$new_val])

 Get/set the number of bytes this peer claims to have uploaded.

=item $peer->downloaded([$new_val])

 Get/set the number of bytes this peer claims to have downloaded.

=item $peer->left([$new_val])

 Get/set the number of bytes this peer claims to have left to download.

=back

=head1 NOTES

  This is alpha software.

  libbtt uses the Apache Portability Runtime (APR) library for it's memory
  management. Perl has it's own memory management system, and the code
  to keep them in sync has not been completely foolproofed.
  
  This does not cause any major problem so long as you pay attention to the
  scope of your variables; first, never use an Infohash object after the Tracker
  object that created it is gone, and second, never use a Peer object after
  the Infohash object that created it is gone.

  When a multi-process tracker is running, the less Infohash or Peer
  objects you keep defined at a time the better. If you are modifying
  them, the quicker you save them after loading them, the better.

=head1 SEE ALSO

  Apache::ModBT

=head1 AUTHOR

  Tyler 'Crackerjack' MacDonald, E<lt>tyler@yi.orgE<gt>

=head1 COPYRIGHT AND LICENSE

  Copyright (C) 2004 by Tyler 'Crackerjack' MacDonald

  This library is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself, either Perl version 5.8.4 or,
  at your option, any later version of Perl 5 you may have available.

=cut
