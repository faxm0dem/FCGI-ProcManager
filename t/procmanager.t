# -*- perl -*-
# Copyright (c) 2000, FundsXpress Financial Network, Inc.
# This library is free software released "AS IS WITH ALL FAULTS"
# and WITHOUT ANY WARRANTIES under the terms of the GNU Lesser
# General Public License, Version 2.1, a copy of which can be
# found in the "COPYING" file of this distribution.

# $Id: procmanager.t,v 1.4 2001/01/13 06:44:35 muaddib Exp $

use strict;
use Test;

BEGIN { plan tests => 6; }

use FCGI::ProcManager;

my $m;

ok $m = FCGI::ProcManager->new();
ok $m->pm_state() eq "idle";

ok $m->n_processes(100) == 100;
ok $m->n_processes(2) == 2;
ok $m->n_processes(0) == 0;

ok $m->pm_manage();

#ok $m->n_processes(-3);
#eval { $m->pm_manage(); };
#ok $@ =~ /dying from number of processes exception: -3/;
#undef $@;

$m->n_processes(20);

#$m->pm_manage();
#sample_request_loop($m);

exit 0;

sub sample_request_loop {
  my ($m) = @_;

  while (1) {
    # Simulate blocking for a request.
    my $t1 = int(rand(2)+1);
    print "$$ waiting for $t1..\n";
    sleep $t1;
    # (Here is where accept-fail-on-intr would exit request loop.)

    $m->pm_pre_dispatch();

    # Simulate a request dispatch.
    my $t = int(rand(3)+1);
    print "$$ sleeping $t..\n";
    while (my $nslept = sleep $t) {
      $t -= $nslept;
      last unless $t;
    }

    $m->pm_post_dispatch();
  }
}
