*** lib/readline/bind.c.orig	Thu Jan 24 11:15:52 2002
--- lib/readline/bind.c	Wed Jul 31 09:11:18 2002
***************
*** 312,316 ****
  	     and the function bound  to `a' to be executed when the user
  	     types `abx', leaving `bx' in the input queue. */
! 	  if (k.function /* && k.type == ISFUNC */)
  	    {
  	      map[ANYOTHERKEY] = k;
--- 312,316 ----
  	     and the function bound  to `a' to be executed when the user
  	     types `abx', leaving `bx' in the input queue. */
! 	  if (k.function && ((k.type == ISFUNC && k.function != rl_do_lowercase_version) || k.type == ISMACR))
  	    {
  	      map[ANYOTHERKEY] = k;

