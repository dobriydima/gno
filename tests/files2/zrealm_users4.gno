package main

// SEND: 2000gnot

import (
	"gno.land/p/testutils"
	"gno.land/r/users"
	"std"
)

const admin = std.Address("g1us8428u2a5satrlxzagqqa5m6vmuze025anjlj")

func main() {
	caller := std.GetOrigCaller() // main
	users.Register("", "gnouser", "my profile")
	// as admin, grant invites to gnouser
	std.TestSetOrigCaller(admin)
	users.GrantInvites(caller.String() + ":1")
	// switch back to caller
	std.TestSetOrigCaller(caller)
	// invite another addr
	test1 := testutils.TestAddress("test1")
	test2 := testutils.TestAddress("test2")
	users.Invite(test1.String())
	// switch to test2 (not test1)
	std.TestSetOrigCaller(test2)
	std.TestSetOrigSend(std.Coins{{"dontcare", 1}}, nil)
	users.Register(caller, "satoshi", "my other profile")
	println("done")
}

// Error:
// invalid invitation
