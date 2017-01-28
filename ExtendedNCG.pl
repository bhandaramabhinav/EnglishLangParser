:-['stats.pl'].


:-op(400,xfx,(/)).
:-op(400,xfx,(\)).

% generates lists of CG terminals with 2 primitive types
% entity (e) and truth value (t)

cg(e,N,N).
cg(t,N,N).
cg(C,s(N1),N3):-cg(A,N1,N2),cg(B,N2,N3),lean(A,B,C).

lean(A,B,A/B).
lean(A,B,A\B).

cgs([],N,N).
cgs([X|Xs],s(N1),N3):-cg(X,N1,N2),cgs(Xs,N2,N3).


cg(N,X):-cg(X,N,0).

cgs(N,X):-cgs(X,N,0).


% reducibles with CYK-like algorithm (but slower complexity-wise)
% might benefit from some form of tabling?

rcg(N,X):-cg(X,N,0),red(X).

rcgs(N,X):-cgs(X,N,0),red(X).

% reduces a sequence of terms to t
red(Xs):-red(Xs,s).

% reduces a sequence to a top symbol R
red(Xs,R):-xred(Xs,[R]),!.

xred(Xs,R):-sel2(X,Y,Z,Xs,Ys),red2(X,Y,Z),xred(Ys,R).
xred([S],[S]).

% select 2 nondeterministically

sel2(X,Y,Z,[X,Y|Xs],[Z|Xs]).
sel2(X,Y,Z,[A|Xs],[A|Ys]):-sel2(X,Y,Z,Xs,Ys).

% reduction rules

red2(X/Y,Y, X).
%changed reduction rule to A,A\B-->B.
red2(Y,Y\X, X).
red2(X/Y,Y/Z, X/Z).
red2(Y\Z,X\Y, X\Z).


% test data for a simple English sentence
% using 3 primitive types np,n,s.

% categories

nounphrase-->[np].
noun-->[n].
adj-->[n/n].
det-->[np/n].
transverbs-->[(np\s)/np].
intransverbs-->[np\s].
auxverbs-->[(np\s)/(np\s)].
conjuctions-->[(s\s)/s].
preposition-->[(np\np)/np].


he-->nounphrase.
the-->det.
bad-->adj.
boy-->noun.
made-->transverbs.
that-->det.
mess-->noun.
runs-->intransverbs.
she-->nounphrase.
loves-->transverbs.
%used iis to represent is as prolog is not allowing to use is.
iis-->transverbs.
animals-->nounphrase.
a-->det.
old-->adj.
man-->noun.
ball-->noun.
park-->noun.
in-->preposition.
kicked-->transverbs.
knows-->intransverbs.
walks-->intransverbs.
if-->conjuctions.
mary-->nounphrase.
john-->nounphrase.



sent-->the,bad,boy,runs.
sent-->the,bad,boy,made,that,mess.
sent-->she,loves,animals.
sent-->the,old,man,kicked,a,ball,in,the,park.
sent-->he,iis,a,bad,boy.
sent-->mary,walks,if,john,walks.

%negative test cases
sent1-->she,animals,loves.
sent2-->boy,bad,he,iis.

go:-sent(S,[]),red(S),writeln(S).
go:-sent1(S,[]),red(S).
go:-sent2(S,[]),red(S).


% helpers for testing all reductions of given size
% rely on helpers in stats.pl

cs(N):-counts(N,cgs(_,_)).
bs(N):-times(N,cgs(_,_)).
ss(N):-show(N,cgs(_,_)).

cr(N):-counts(N,rcgs(_,_)).
br(N):-times(N,rcgs(_,_)).
sr(N):-show(N,rcgs(_,_)).


