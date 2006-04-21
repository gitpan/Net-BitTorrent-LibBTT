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
our $VERSION = '0.014';

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

=head3 C<< $tracker = Net::BitTorrent::LibBTT::Tracker->new($dir, [$master]) >>

Connects to, or creates, a LibBTT tracker database.
If C<$master> is specified, a new database and shared memory region are created.

If you are writing a script to be used in the mod_perl environment, use
the Apache::ModBT module to initialize your tracker object instead; that
module will connect you to an existing tracker object instead of creating a
new one, which is far more efficient.

=head3 CONNECTION ACTIONS

=over

=item C<< $tracker->cxn_announce($args, $user_agent, $addr, $port) >>

Process an "/announce" connection. C<$args> are the URL arguments (info_hash=blah&peer_id=blah&etc),
C<$user_agent> is the "User-Agent" header sent by the client, C<$addr> is the remote address,
as an integer, in network byte order (If you're using an L<IO::Socket::INET> object, you can
get this with "C<< $address = unpack('L', $socket->peeraddr); >>"), and C<$port> is the remote
port, in host byte order (C<< $socket->peerport >> returns this).

The return value is an array. The first element is the HTTP status code to return,
the second element is the length of the content, and the third element is the
content itself.

=item C<< $tracker->cxn_details($args, $addr, $port) >>

=item C<< $tracker->cxn_register($args, $addr, $port) >>

=item C<< $tracker->cxn_scrape($args, $addr, $port) >>

Process "details", "announce", and "scrape" requests, respectively. The arguments have
the same meanings as they do in C<< $tracker->cxn_announce() >>, and the return value
is also the same.

If you wish to get a root HTML info page, specify "html=1" in C<< $args >> for
C<< $tracker->cxn_scrape() >>.

=back

=head3 C<< Net::BitTorrent::LibBTT::Flags() >>

Returns an array of key/value pairs for every flag that this
tracker supports.

The keys returned are the flags' binary values, and the values
returned are the flags' configuration names.

=head3 C<< $tracker->c >>

Returns a C<Net::BitTorrent::LibBTT::Tracker::Config> object which allows
the tracker's configuration data to be retrieved and set. Consult the
libbtt documentation for the meanings of each of these configuration
values.

=head4 C<< Net::BitTorrent::LibBTT::Tracker::Config >> Methods

=over

=item C<< $c->stylesheet([$new_val]) >>

Gets/sets the URI for the stylesheet to be used on HTML pages generated
by the tracker.

=item C<< $c->db_dir() >>

Returns the directory on the filesystem where the database is kept.

=item C<< $c->flags([$new_val]) >>

Gets/sets the tracker configuration's flags.

NOTE: It is NOT safe to clear the flags and re-set them the way you want.
You must always first obtain the current flags, and then only set/clear
the ones you intend to change. Not all bits in C<$new_val> will have been
defined by the L</Net::BitTorrent::LibBTT::Flags()> function; some are used internally. You can 
really screw your tracker up if you are not careful when re-setting flags!

=item C<< $c->random_retry([$new_val]) >>

Gets/sets the number of times "random" operations should be allowed to
iterate if unsuccessful. Currently, the main "random" operation is picking
peers off of a peerlist to return to a client; the higher this value, 
the more times the tracker will retry building peerlists for C<< /announce >>
requests if random selection does not return any peers.

=item C<< $c->return_peers([$new_val]) >>

Gets/sets the default number of peers to return on C</announce> requests.

=item C<< $c->return_interval([$new_val]) >>

Gets/sets the base return interval to return to peers on C</anounce> requests.

=item C<< $c->return_max([$new_val]) >>

Gets/sets the maximum number of peers to return on /announce requests.

=item C<< $c->return_peer_factor([$new_val]) >>

Gets/sets the "return peer factor". This value is used to increase
peers' return intervals as more peers are added to an infohash.

The following formula is used to calculate what interval to return to
a peer:

=over

	peer.return_interval = ((tracker.return_peer_factor / infohash.peers) + 1) * tracker.return_interval

=back

So, with a tracker C<return_interval> of 500 seconds, and a C<return_peer_factor> of 20,

=over

=item *
An infohash with 10 peers would tell it's peers to return every 500 seconds,

=item *
an infohash with 22 peers would tell it's peers to return every 1000 seconds,

=item *
an infohash with 1000 peers would tell it's peers to return every 500000 seconds,

=item *
etc.

=back

The default C<return_interval> setting is 1000. Setting it below 100 would probably cause problems
on very popular torrents.

=item C<< $c->hash_watermark([$new_val]) >>

Gets/sets the hash watermark, which is how many hashes need to be in existance
before hashes between "hash_min_age" and "hash_max_age" are deleted.

=item C<< $c->hash_min_age([$new_val]) >>

Gets/sets the minimum inactivity of an infohash before it is eligible for deletion.

=item C<< $c->hash_max_age([$new_val]) >>

Gets/sets the maximum inactivity of an infohash before it must be deleted.

=item C<< $c->parent_server() >>

If the LibBTT tracker is embedded inside another server, that server will set this
value on startup. (eg; "Apache/2.0.49")

=back

=head3 C<< $tracker->s >>

Returns a C<Net::BitTorrent::LibBTT::Stats> object which may be used
to fetch (and set) statistics on the tracker's internal operation.

=head4 C<Net::BitTorrent::LibBTT::Stats> Methods

=over

=item C<< $s->num_children() >>

This value is incremented/decremented automatically whenever a
tracker instance connects/disconnects from a tracker directory
and should not be modified externally.

=item C<< $s->num_requests([$new_val]) >>

Gets/sets the total number of requests this tracker has processed.

=item C<< $s->num_hashes([$new_val]) >>

Gets/sets the number of hashes on this tracker. Setting this value
is pretty useless, since it is re-set by the tracker frequently to
reflect the actual database value.

=item C<< $s->num_peers([$new_val]) >>

Gets/sets the number of peers on this tracker. Setting this value
is pretty useless, since it is re-set by the tracker frequently to
reflect the actual database value.

=item C<< $s->announces([$new_val]) >>

Gets/sets the number of announce requests this tracker has served.

=item C<< $s->scrapes([$new_val]) >>

Gets/sets the number of scrape requests this tracker has served.

=item C<< $s->full_scrapes([$new_val]) >>

Gets/sets the number of non-specific scrape requests this tracker has served.

=item C<< $s->bad_announces([$new_val]) >>

Gets/sets the number of erronious announce requests this tracker has processed.

=item C<< $s->bad_scrapes([$new_val]) >>

Gets/sets the number of erronious scrape requests this tracker has processed.

=item C<< $s->start_t([$new_val]) >>

Gets/sets the UNIX timestamp when this tracker started up.

=item C<< $s->master_pid([$new_val]) >>

Gets/sets process id of the tracker instance that is responsible for final clean-up on shutdown.
Changing this value can be hazardous!

=item C<< $s->server_time([$new_val]) >>

This value is updated whenever the tracker processes an announce, register, or scrape request.

=back

=head2 INFOHASHES

=head3 Initialization

=over

=item C<< $hash = $tracker->Infohash($hash_id, [$create]) >>

Returns a Net::BitTorrent::LibBTT::Infohash object for the given 20-byte $hash_id.
If $create is set to "1", the hash will be created if it does not already exist.

=item C<< @hashes = $tracker->Infohashes() >>

Returns an array of C<Net::BitTorrent::LibBTT::Infohash> objects, one for each hash
in the tracker's database.

=back

=head3 Methods

=over

=item C<< $hash->save() >>

Copy changes to the C<Net::BitTorrent::LibBTT::Infohash> object back into the tracker
database.

=item C<< $hash->infohash() >>

Return the 20-byte infohash value for this torrent. This value may not be modified;
create a new Infohash object instead.

=item C<< $hash->filename([$new_val]) >>

Gets/sets the filename to report for this hash on the information page.

=item C<< $hash->filesize([$new_val]) >>

Gets/sets the size of the actual file(s) represented by this infohash, in bytes.

=item C<< $hash->max_uploaded() >>

Returns the highest C<uploaded> value reported by any peers currently active on this infohash.

=item C<< $hash->max_downloaded() >>

Returns the highest C<downloaded> value reported by any peers currently active on this infohash.

=item C<< $hash->max_left() >>

Returns the highest C<left> value reported by any peers currently active on this infohash.

=item C<< $hash->min_left() >>

Returns the lowest C<left> value reported by any peers currently active on this infohash,
except for seeds. The only time C<$hash->min_left()> will return zero is if I<all> of the
peers on the infohash are seeds.

=item C<< $hash->hits([$new_val]) >>

Gets/sets the number of times this infohash has been part of an announce request.

=item C<< $hash->peers() >>

Returns the number of peers in this hash. I<If you want to get a list of every actual peer,
use the C<< $hash->Peers() >> method (documented below) instead.>

=item C<< $hash->seeds() >>

Returns the number of seeds in this hash.

=item C<< $hash->shields() >>

Returns the number of shielded seeds in this hash. Shielded seeds are only
returned to other peers if there are absolutely no other seeds available.

=item C<< $hash->starts([$new_val]) >>

Gets/sets the number of C</announce> requests this tracker has processed with
the peer's C<started> attribute set.

=item C<< $hash->stops([$new_val]) >>

Gets/sets the number of C</announce> requests this tracker has processed with
the peer's C<stopped> attribute set.

=item C<< $hash->completes([$new_val]) >>

Gets/sets the number of /announce requests this tracker has processed with
the peer's C<completed> attribute set.

=item C<< $hash->first_t() >>

Returns the UNIX timestamp for when this hash was first placed in the database.

=item C<< $hash->last_t([$new_val]) >>

Returns the timestamp for when this hash was last processed.

=item C<< $hash->register_t([$new_val]) >>

Returns the timestamp for when this hash was registered. Hashes with a C<register_t> value
other than 0 will not ever be deleted by the tracker's garbage collection.

=item C<< $hash->first_peer_t() >>

Returns the timestamp for when this hash first had a peer.

=item C<< $hash->last_peer_t() >>

Returns the timestamp for when this hash last had a peer.

=item C<< $hash->first_seed_t() >>

Returns the timestamp for when this hash first had a seed.

=item C<< $hash->last_seed_t() >>

Returns the timestamp for when this hash last had a seed.

=back

=head2 PEERS

Peers are always returned from Infohashes.

=head3 Functions

=over

=item C<< Net::BitTorrent::LibBTT::Peer::Flags() >>

Returns a list of key/value pairs, the keys being valid 
binary flag values for a peer, the values being the configuration
names of those flags.

=back

=head3 Initialization

=over

=item C<< $peer = $hash->Peer($peer_id) >>

Given the 20-byte peer_id, return a C<Net::BitTorrent::LibBTT::Peer> object from the database
associated with that peer. If the peer does not exist, it will be created.

=item C<< @peers = $hash->Peers() >>

Return all peers associated with a given hash.

B<NOTE:> When dealing with peers, it is ABSOLUTELY VITAL at this point that you do not attempt
to access C<Net::BitTorrent::LibBTT::Peer> objects after the C<Net::BitTorrent::LibBTT::Infohash> object
that created them has been destroyed!!!

=back

=head3 Methods

=over

=item C<< $peer->save() >>

Store the object's information in the database. As with infohashes, care should be taken that
a C<< $peer->save() >> call happens as quickly as possible after the peer object is loaded.

=item C<< $peer->peerid() >>

Returns the 20-byte peer id associated with this peer.

=item C<< $peer->infohash() >>

Returns the 20-byte infohash associated with this peer.

=item C<< $peer->flags([$new_val]) >>

Get/set this peer's flags as a bitmask. The meanings of each bit are returned by the
L</Net::BitTorrent::LibBTT::Peer::Flags()> function.

=item C<< $peer->ua([$new_val]) >>

Get/set the User-Agent of the peer.

=item C<< $peer->event([$new_val]) >>

Get/set the last C<event> string this peer returned.

=item C<< ($addr, $port) = $peer->address([$new_addr[, $new_port]]) >>

Get/set the peers's reported IP address and port.
IP addresses are returned/specified as a 4-byte string in network byte order,
suitable for passing to "inet_ntoa".
Ports are returned as an integer value in host byte order.

=item C<< ($addr, $port) = $peer->real_address([$new_addr[, $new_port]]) >>

Get/set the peers's detected IP address and port.

=item C<< $peer->first_t([$new_val]) >>

Get/set the timestamp for when this peer first connected to the tracker.

=item C<< $peer->last_t([$new_val]) >>

Get/set the timestamp for when this peer last connected to the tracker.

=item C<< $peer->first_serve_t([$new_val]) >>

Get/set the timestamp for the first time this peer was served to another peer.

=item C<< $peer->last_serve_t([$new_val]) >>

Get/set the timestamp for the last time this peer was served to another peer.

=item C<< $peer->complete_t([$new_val]) >>

Get/set the timestamp for when this peer reported that it was done downloading, if ever.

=item C<< $peer->return_interval([$new_val]) >>

Get/set the return interval last returned to this peer.

=item C<< $peer->hits([$new_val]) >>

Get/set the number of times this peer has connected to the tracker.

=item C<< $peer->serves([$new_val]) >>

Get/set the number of times this peer has been served to other peers.

=item C<< $peer->num_want([$new_val]) >>

Get/set the number of peers this peer asked for on it's last C</announce> request.

=item C<< $peer->num_got([$new_val]) >>

Get/set the number of peers this peer was sent on it's last C</announce> request.

=item C<< $peer->announce_byes([$new_val]) >>

Get/set the total number of bytes that have been sent to this peer in C</announce> responses.

=item C<< $peer->uploaded([$new_val]) >>

Get/set the number of bytes this peer claims to have uploaded.

=item C<< $peer->downloaded([$new_val]) >>

Get/set the number of bytes this peer claims to have downloaded.

=item C<< $peer->left([$new_val]) >>

Get/set the number of bytes this peer claims to have left to download.

=back

=head1 NOTES

This is a pole for perl.

While C<libbtt> itself is, C<Net::BitTorrent::LibBTT> is B<not> transactional.
This is to prevent perl scripts from affecting the operations of the tracker.
If you are saving data to the tracker's database, it is always best to do so as
quickly as possible after loading the data, otherwise your save may overwrite
a tracker update.

=head1 SEE ALSO

L<Apache::ModBT>, L<http://www.crackerjack.net/mod_bt/>, Socket(3), perlfunc, L<IO::Socket::INET>

=head1 AUTHOR

Tyler 'Crackerjack' MacDonald, <tyler@yi.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Tyler 'Crackerjack' MacDonald

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
