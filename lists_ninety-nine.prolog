:- use_module(library(lists)).
:- use_module(library(random)).

%Find the last element of a list
get_last(X,[X]) :- !.
get_last(X,[A|B]) :- get_last(X,B).

%Find the last but one element of a list
penultimate(X,[X,A]) :- !.
penultimate(X,[A|B]) :- penultimate(X,B).

% Find the K'th element of a list (base 1)
element_at(X,[X|_],1) :- !.
element_at(X,[A|B],K) :- N is K-1, element_at(X,B,N).

%Find the number of elements of a list.
length_of(0,[]).
length_of(N,[A|B]) :- length_of(K,B), N is K+1.

%Reverse a list
my_reverse([],[]).
my_reverse(K,[A|B]) :- my_reverse(R,B), append(R,[A],K).

%Find out whether a list is a palindrome.
palindrome(A) :- reverse(A,A).

%Flatten a nested list structure.
my_flatten([],[]) :- !.
my_flatten(A,[A]) :- not(is_list(A)), !.
my_flatten([A|B],R) :- my_flatten(A,AR), my_flatten(B,BR), append(AR,BR,R).

%Eliminate consecutive duplicates of list elements.
compress([],[]) :- !.
compress([A|[]],[A]) :- !.
compress([A,A|B],R) :- compress([A|B],R), !.
compress([A,C|B],[A|R]) :- compress([C|B],R).

%Pack consecutive duplicates of list elements into sublists
pack([],[]).
pack([A,A|C],R) :- not(is_list(A)), pack([[A,A]|C],R), !.
pack([A,B|C],[[A]|R]) :- not(is_list(A)), pack([B|C], R), !.
pack([[A|B],A|C],R) :- pack([[A,A|B]|C],R), !.
pack([A|B],[A|R]) :- pack(B,R).

%Run-length encoding of a list.
encode([],[]).
encode([A|B],[[L,AH]|R]) :- pack([A|B],[[AH|AR]|BR]), length([AH|AR],L), my_flatten(BR,AUX), encode(AUX,R).

%................ 10 .................

%1.11 (*) Modified run-length encoding.
encode_modified([],[]).
encode_modified([A|B],[[L,AH]|R]) :- pack([A|B],[[AH|AR]|BR]), length([AH|AR],L), L > 1, my_flatten(BR,AUX), encode_modified(AUX,R), !.
encode_modified([A|B],[AH|R]) :- pack([A|B],[[AH|AR]|BR]), length([AH|AR],L), my_flatten(BR,AUX), encode_modified(AUX,R).

%1.12 (**) Decode a run-length encoded list.
%Given a run-length code list generated as specified in problem 1.11. Construct its uncompressed version.
decode([],[]).
decode([[L,A]|B],RR) :- repeat(L,A,AR), decode(B,R), append(AR,R, RR).

repeat([],[]).
repeat(1,A,[A]).
repeat(L,A,R) :- LL is L-1, repeat(LL,A,AR), append(AR,[A],R).

%1.13 (**) Run-length encoding of a list (direct solution). (tricky one)
encode_direct([],[]).
encode_direct([A|B],[C|R]) :- count(A,B,D,1,C), encode_direct(D,R).

count(A,[],[],1,A).
count(A,[],[],L,[L,A]) :- L > 1.
count(A,[A|C],D,L,T) :- LL is L + 1, count(A,C,D,LL,T), !.
count(A,[B|C],[B|C],1,A).
count(A,[B|C],[B|C],L,[L,A]).

%1.14 (*) Duplicate the elements of a list.
dupli([],[]).
dupli([A|B],[A,A|R]) :- dupli(B,R).

%1.15 (**) Duplicate the elements of a list a given number of times.
dupli_n([],_,[]).
dupli_n([A|B],N,R) :- ntimes(A,N,AR), dupli_n(B,N,RR), append(AR,RR,R).

ntimes(A,0,[]).
ntimes(A,1,[A]).
ntimes(A,N,[A|R]) :- NN is N-1, ntimes(A,NN,R).

%1.16 (**) Drop every N'th element from a list.
drop([],_,[]).
drop([A|B],1,B).
drop([A|B],N,[A|R]) :- NN is N-1, drop(B,NN,R).

%1.17 (*) Split a list into two parts; the length of the first part is given.
split([],_,[],[]).
split([A|B],0,[],[A|B]).
split([A|B],N,[A|R1],R2) :- NN is N-1, split(B,NN,R1,R2).

%1.18 (**) Extract a slice from a list.
slice([],_,_,[]).
slice([A|B],1,1,[A]).
slice([A|B],1,N,R) :- NN is N-1, slice(B,1,NN,RR), append([A],RR,R), !.
slice([A|B],N1,N2,R) :- NN1 is N1-1, NN2 is N2-1, slice(B,NN1,NN2,R).

%1.19 (**) Rotate a list N places to the left.
rotate([],_,[]).
rotate(A,N,R) :- N<0, length(A,L),  NN is L+N, split(A,NN,L1,L2), append(L2,L1,R), !.
rotate(A,N,R) :- split(A,N,L1,L2), append(L2,L1,R).

%1.20 (*) Remove the K'th element from a list.
remove_at([],[],_,[]).
remove_at(A,[A|B],1,B).
remove_at(X,[A|B],N,[A|R]) :- NN is N-1, remove_at(X,B,NN,R).

%................................ 20 ..................................

%1.21 (*) Insert an element at a given position into a list.
insert_at(X,[],_,[X]).
insert_at(X,A,1,[X|A]).
insert_at(X,[A|B],N,[A|R]) :- NN is N-1, insert_at(X,B,NN,R).

%1.22 (*) Create a list containing all integers within a given range.
range(N,N,[N]).
range(N1,N2,[N1|R]) :- NN is N1+1, range(NN,N2,R).

%1.23 (**) Extract a given number of randomly selected elements from a list.
rnd_select([],_,[]).
rnd_select(A,1,[X]) :- length_of(L,A), random(1,L,Rnd), remove_at(X,A,Rnd,_), !.
rnd_select(A,N,[X|R]) :- NN is N-1, length_of(L,A), random(1,L,Rnd), remove_at(X,A,Rnd,RR), rnd_select(RR,NN,R).

%1.24 (*) Lotto: Draw N different random numbers from the set 1..M.
rnd_range_select(N1,N2,R) :- range(N1,N2,RR), length_of(L,RR), random(1,L,X), rnd_select(RR,X,R).

%1.25 (*) Generate a random permutation of the elements of a list.
rnd_permu([],[]).
rnd_permu(A,[X|R]) :- length(A,L), random(1,L,N), remove_at(X,A,N,RR), rnd_permu(RR,R).

%1.26 (**) Generate the combinations of K distinct objects chosen from the N elements of a list
combination(0,_,[]).
combination(N,A,[X|R]) :-N > 0, NN is N-1, el(X,A,RR), combination(NN,RR,R).

el(A,[A|L],L).
el(A,[_|L],R) :- el(A,L,R).

%1.27 (**) Group the elements of a set into disjoint subsets.
group([],_,[]).
group(X,[A,B,C],[AR,BR,CR]) :- combination(A,X,AR), subtract(X,AR,XA), combination(B,XA,BR), subtract(XA,BR,XC), combination(C,XC,CR).

%1.28 (**) Sorting a list of lists according to length of sublists
%a)
lsort([],[]).
lsort(A,R) :- keygen(A,RR), keysort(RR,RRR), del_key(RRR,R).

keygen([],[]).
keygen([X|Xs],[L-X|R]) :- length(X,L), keygen(Xs,R).

del_key([],[]).
del_key([K-X|Xs],[X|R]) :- del_key(Xs,R).
%b)
lfsort([],[]).
lfsort(A,R) :- lsort(A,RR), group_byl(RR,RG), lsort(RG,RS), super_append(RS,R).

group_byl([],[]).
group_byl([A,B|C],[XR|Xs]) :- length(A,L), length(B,L), group_byl([B|C],[X|Xs]), append([A],X,XR).
group_byl([A|B],[[A]|R]) :- group_byl(B,R).

super_append([],[]).
super_append([A|B],R) :- super_append(B,RR), append(A,RR,R).
				 
