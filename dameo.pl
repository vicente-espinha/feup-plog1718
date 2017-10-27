

board_start([
	[1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1],
	[0,0,1,1,1,1,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,2,2,2,2,0,0],
	[0,2,2,2,2,2,2,0],
	[2,2,2,2,2,2,2,2]
]).

board_midgame([
	[1,1,1,1,1,1,1,0],
	[0,0,0,0,0,0,1,0],
	[0,1,1,0,1,1,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,2,0,2,2,0],
	[0,0,0,2,2,0,0,0],
	[0,0,0,0,2,0,2,0],
	[2,2,3,2,0,2,2,2]
]).

board_end([
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,1,0,0,0,0],
	[3,0,0,0,0,0,0,0]
]).



show_board([],_) :- 
	write('  ---------------------------------\n'),
	write('    A   B   C   D   E   F   G   H  \n').

show_board([A|B],N) :-	
	write('  ---------------------------------\n'),
	write(N),
  	show_line(A),
  	nl,
  	N1 is N+1,
  	show_board(B,N1).


show_line([]) :- write(' | ').
show_line([A|B]) :-
  	write(' | '),
  	analyse_piece(A),
  	show_line(B).

analyse_piece(X) :-
 	blank_space(X); 
 	first_team(X); 
 	second_team(X);
 	first_team_king(X);
 	second_team_king(X).


blank_space(X) :- X =:= 0, write(' '). 
first_team(X) :- X =:= 1, write('o').
second_team(X) :- X =:= 2, write('x').
first_team_king(X) :- X =:= 3, write('O').
second_team_king(X) :- X =:= 4, write('X').

print :- board_start(X), show_board(X,1).

