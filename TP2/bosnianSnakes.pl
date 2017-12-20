:-use_module(library(clpfd)).
:-use_module(library(lists)).


puzzle(6,
[1,A2,A3,A4,A5,A6,
B1,B2,B3,B4,B5,B6,
C1,C2,C3,C4,6,C6,
D1,6,D3,D4,D5,D6,
E1,E2,E3,E4,E5,E6,
F1,F2,F3,F4,F5,1]).


start:-
    %declaracao de variaveis
    puzzle(SIZE,BOARD),

    %declaracao do dominio
    domain(BOARD,0,9),

    %declaracao de restricoes
    around(BOARD,SIZE,1),

    %pesquisa de solucoes
    reset_timer,
    labeling([ffc],BOARD),
    display_aux(SIZE),
    display_board(BOARD,SIZE,SIZE,SIZE),
    print_time,
    fd_statistics.


/*************LOGIC****************/


%around é o predicado que verifica se tem o numero de pintadas igual ao valor do numero
around([],_,_).
around([H|T],SIZE,I):-
    NewI is I + 1,
    around(T,SIZE,NewI),
    ((nonvar(H),
    check_up(BOARD,SIZE,I,UP),
    check_down(BOARD,SIZE,I,DOWN),
    check_right(BOARD,SIZE,I,RIGHT),
    check_left(BOARD,SIZE,I,LEFT),
    check_left_up(BOARD,SIZE,I,LEFTUP),
    check_left_down(BOARD,SIZE,I,LEFTDOWN),
    check_right_up(BOARD,SIZE,I,RIGHTUP),
    check_right_down(BOARD,SIZE,I,RIGHTDOWN),
    sum([UP,DOWN,RIGHT,LEFT,LEFTUP,LEFTDOWN,RIGHTUP,RIGHTDOWN],#=,H));true).


check_down(BOARD,SIZE,I,VALUE):-
     V is I + SIZE,
     ((V > SIZE * SIZE,VALUE is 0);(nth1(V,BOARD,VALUE))).

check_right_down(BOARD,SIZE,I,VALUE):-
    V is I + SIZE + 1,
    ((V > SIZE * SIZE,VALUE is 0);(nth1(V,BOARD,VALUE))).

check_left_down(BOARD,SIZE,I,VALUE):-
    V is I + SIZE - 1,
    ((V > SIZE * SIZE,VALUE is 0);(nth1(V,BOARD,VALUE))).

check_right(BOARD,SIZE,I,VALUE):-
    V is I + 1,
    ((V > SIZE * SIZE,VALUE is 0);(nth1(V,BOARD,VALUE))).

check_up(BOARD,SIZE,I,VALUE):-
    V is I - SIZE,
    ((V < 1,VALUE is 0);(nth1(V,BOARD,VALUE))).

check_left(BOARD,_,I,VALUE):-
    V is I - 1,
    ((V < 1,VALUE is 0);(nth1(V,BOARD,VALUE))).

check_left_up(BOARD,SIZE,I,VALUE):-
    V is I - SIZE - 1,
    ((V < 1,VALUE is 0);(nth1(V,BOARD,VALUE))).

check_right_up(BOARD,SIZE,I,VALUE):-
    V is I - SIZE + 1,
    ((V < 1,VALUE is 0);(nth1(V,BOARD,VALUE))).



/***************DISPLAY******************/

display_board(_,_,_,0).

display_board(Board,Size,0,Counter):-
  Counter1 is Counter - 1,
  write('|'),nl,
  display_aux(Size),
  LineSize is Size,
  display_board(Board,Size,LineSize,Counter1).

display_board([H|Tail],Size,LineSize,Counter):-
  Counter > 0,
  write('|'),
  write(H),
  Size1 is LineSize - 1,
  display_board(Tail,Size,Size1,Counter).

display_aux(0):-nl.
display_aux(Size):-
  Size > 0,
  write('--'),
  Size1 is Size - 1,
  display_aux(Size1).

/***********statistics*********/

reset_timer:- statistics(walltime,_).

print_time:-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time:'), write(TS), write('s'), nl.
