#define PERL_constant_NOTFOUND	1
#define PERL_constant_NOTDEF	2
#define PERL_constant_ISIV	3
#define PERL_constant_ISNO	4
#define PERL_constant_ISNV	5
#define PERL_constant_ISPV	6
#define PERL_constant_ISPVN	7
#define PERL_constant_ISSV	8
#define PERL_constant_ISUNDEF	9
#define PERL_constant_ISUV	10
#define PERL_constant_ISYES	11

#ifndef NVTYPE
typedef double NV; /* 5.6 and later define NVTYPE, and typedef NV to it.  */
#endif
#ifndef aTHX_
#define aTHX_ /* 5.6 or later define this for threading support.  */
#endif
#ifndef pTHX_
#define pTHX_ /* 5.6 or later define this for threading support.  */
#endif

static int
constant_11 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     BT_HASH_LEN BT_PATH_LEN HTTP_LOCKED */
  /* Offset 5 gives the best switch position.  */
  switch (name[5]) {
  case 'L':
    if (memEQ(name, "HTTP_LOCKED", 11)) {
    /*                    ^            */
#ifdef HTTP_LOCKED
      *iv_return = HTTP_LOCKED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "BT_HASH_LEN", 11)) {
    /*                    ^            */
#ifdef BT_HASH_LEN
      *iv_return = BT_HASH_LEN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "BT_PATH_LEN", 11)) {
    /*                    ^            */
#ifdef BT_PATH_LEN
      *iv_return = BT_PATH_LEN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_14 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     BT_PEERSTR_LEN BT_TINY_STRING HTTP_NOT_FOUND */
  /* Offset 13 gives the best switch position.  */
  switch (name[13]) {
  case 'D':
    if (memEQ(name, "HTTP_NOT_FOUN", 13)) {
    /*                            D      */
#ifdef HTTP_NOT_FOUND
      *iv_return = HTTP_NOT_FOUND;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'G':
    if (memEQ(name, "BT_TINY_STRIN", 13)) {
    /*                            G      */
#ifdef BT_TINY_STRING
      *iv_return = BT_TINY_STRING;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "BT_PEERSTR_LE", 13)) {
    /*                            N      */
#ifdef BT_PEERSTR_LEN
      *iv_return = BT_PEERSTR_LEN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_15 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     BT_EMPTY_PEERID BT_INFOHASH_LEN BT_SHORT_STRING */
  /* Offset 6 gives the best switch position.  */
  switch (name[6]) {
  case 'O':
    if (memEQ(name, "BT_INFOHASH_LEN", 15)) {
    /*                     ^               */
#ifdef BT_INFOHASH_LEN
      *iv_return = BT_INFOHASH_LEN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "BT_SHORT_STRING", 15)) {
    /*                     ^               */
#ifdef BT_SHORT_STRING
      *iv_return = BT_SHORT_STRING;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "BT_EMPTY_PEERID", 15)) {
    /*                     ^               */
#ifdef BT_EMPTY_PEERID
      *iv_return = BT_EMPTY_PEERID;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_17 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     BT_EMPTY_INFOHASH HTTP_SERVER_ERROR HTTP_UNAUTHORIZED */
  /* Offset 5 gives the best switch position.  */
  switch (name[5]) {
  case 'P':
    if (memEQ(name, "BT_EMPTY_INFOHASH", 17)) {
    /*                    ^                  */
#ifdef BT_EMPTY_INFOHASH
      *iv_return = BT_EMPTY_INFOHASH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "HTTP_SERVER_ERROR", 17)) {
    /*                    ^                  */
#ifdef HTTP_SERVER_ERROR
      *iv_return = HTTP_SERVER_ERROR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'U':
    if (memEQ(name, "HTTP_UNAUTHORIZED", 17)) {
    /*                    ^                  */
#ifdef HTTP_UNAUTHORIZED
      *iv_return = HTTP_UNAUTHORIZED;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, IV *iv_return) {
  /* Initially switch on the length of the name.  */
  /* When generated this function returned values for the list of names given
     in this section of perl code.  Rather than manually editing these functions
     to add or remove constants, which would result in this comment and section
     of code becoming inaccurate, we recommend that you edit this section of
     code, and use it to regenerate a new set of constant functions which you
     then use to replace the originals.

     Regenerate these constant functions by feeding this entire source file to
     perl -x

#!/usr/bin/perl -w
use ExtUtils::Constant qw (constant_types C_constant XS_constant);

my $types = {map {($_, 1)} qw(IV)};
my @names = (qw(BT_EMPTY_HASH BT_EMPTY_INFOHASH BT_EMPTY_PEERID BT_EVENT_LEN
	       BT_HASH_LEN BT_INFOHASH_LEN BT_PATH_LEN BT_PEERID_LEN
	       BT_PEERSTR_LEN BT_SHORT_STRING BT_TINY_STRING HTTP_BAD_REQUEST
	       HTTP_CREATED HTTP_LOCKED HTTP_NOT_FOUND HTTP_OK
	       HTTP_SERVER_ERROR HTTP_UNAUTHORIZED));

print constant_types(); # macro defs
foreach (C_constant ("Net::BitTorrent::LibBTT", 'constant', 'IV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "#### XS Section:\n";
print XS_constant ("Net::BitTorrent::LibBTT", $types);
__END__
   */

  switch (len) {
  case 7:
    if (memEQ(name, "HTTP_OK", 7)) {
#ifdef HTTP_OK
      *iv_return = HTTP_OK;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 11:
    return constant_11 (aTHX_ name, iv_return);
    break;
  case 12:
    /* Names all of length 12.  */
    /* BT_EVENT_LEN HTTP_CREATED */
    /* Offset 5 gives the best switch position.  */
    switch (name[5]) {
    case 'C':
      if (memEQ(name, "HTTP_CREATED", 12)) {
      /*                    ^             */
#ifdef HTTP_CREATED
        *iv_return = HTTP_CREATED;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'E':
      if (memEQ(name, "BT_EVENT_LEN", 12)) {
      /*                    ^             */
#ifdef BT_EVENT_LEN
        *iv_return = BT_EVENT_LEN;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 13:
    /* Names all of length 13.  */
    /* BT_EMPTY_HASH BT_PEERID_LEN */
    /* Offset 6 gives the best switch position.  */
    switch (name[6]) {
    case 'R':
      if (memEQ(name, "BT_PEERID_LEN", 13)) {
      /*                     ^             */
#ifdef BT_PEERID_LEN
        *iv_return = BT_PEERID_LEN;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'T':
      if (memEQ(name, "BT_EMPTY_HASH", 13)) {
      /*                     ^             */
#ifdef BT_EMPTY_HASH
        *iv_return = BT_EMPTY_HASH;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 14:
    return constant_14 (aTHX_ name, iv_return);
    break;
  case 15:
    return constant_15 (aTHX_ name, iv_return);
    break;
  case 16:
    if (memEQ(name, "HTTP_BAD_REQUEST", 16)) {
#ifdef HTTP_BAD_REQUEST
      *iv_return = HTTP_BAD_REQUEST;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 17:
    return constant_17 (aTHX_ name, iv_return);
    break;
  }
  return PERL_constant_NOTFOUND;
}

