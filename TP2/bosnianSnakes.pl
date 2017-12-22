:-use_module(library(clpfd)).
:-use_module(library(lists)).


puzzle(6,
[1,A2,A3,A4,A5,A6,
B1,B2,B3,B4,B5,B6,
C1,C2,C3,C4,6,C6,
D1,6,D3,D4,D5,D6,
E1,E2,E3,E4,E5,E6,
F1,F2,F3,F4,F5,1],
[_,2,_,_,1,_],
[_,_,_,_,_,_]).


start:-
    %declaracao de variaveis
    puzzle(SIZE,BOARD,VERTICAL,HORIZONTAL),

    %declaracao do dominio
    init_domain(BOARD),

    %declaracao de restricoes
    around(BOARD,SIZE,2),
    vertical_restrictions(BOARD,SIZE,VERTICAL,1),
    horizontal_restrictions(BOARD,SIZE,HORIZONTAL,1),
    continues(BOARD,SIZE,1),

    %pesquisa de solucoes
    reset_timer,
    labeling([ffc],BOARD),
    display_aux(SIZE),
    display_board(BOARD,SIZE,SIZE,SIZE),
    print_time,
    fd_statistics.

%predicado que inicia coloca as variaveis com dominio entre 0 e 1
init_domain([]).
init_domain([H|T]):-
    init_domain(T),
    ((var(H),
    H in 0..1);true).


/*************LOGIC****************/


%around é o predicado que verifica se tem o numero de pintadas igual ao valor do numero
around(_,_,36).
around(BOARD,SIZE,I):-
    NewI is I + 1,
    around(BOARD,SIZE,NewI),
    nth1(I,BOARD,H),
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


continues(_,_,36).
continues(BOARD,SIZE,I):-
    nth1(I,BOARD,VAR),
    (
      VAR \= 1,
      NewI is I + 1,
      continues(BOARD,SIZE,NewI)
    );(VAR = 1,AUX is I mod SIZE,
    (
      ((AUX \= 0, check_right_continues(BOARD,SIZE,I,RIGHT));RIGHT is 0),
      ((check_up_continues(BOARD,SIZE,I,UP))),
      ((check_down_continues(BOARD,SIZE,I,DOWN))),
      ((AUX \= 1, check_left_continues(BOARD,SIZE,I,LEFT));LEFT is 0),
      ((I \= 1,sum([RIGHT,UP,LEFT,DOWN],#=,2));sum([RIGHT,UP,LEFT,DOWN],#=,1)),
      NewI is I + 1,
      continues(BOARD,SIZE,NewI))
      ).


        check_down_continues(BOARD,SIZE,I,VALUE):-
             V is I + SIZE,
             ((V > SIZE * SIZE,VALUE is 0);(nth1(V,BOARD,AUX),((var(AUX),VALUE = AUX);(AUX =:= 1,VALUE is 1);VALUE is 0))).

        check_right_continues(BOARD,SIZE,I,VALUE):-
            V is I + 1,
            ((V > SIZE * SIZE,VALUE is 0);(nth1(V,BOARD,AUX),((var(AUX),VALUE = AUX);(AUX =:= 1,VALUE is 1);VALUE is 0))).

        check_up_continues(BOARD,SIZE,I,VALUE):-
            V is I - SIZE,
            ((V < 1,VALUE is 0);(nth1(V,BOARD,AUX),((var(AUX),VALUE = AUX);(AUX =:= 1,VALUE is 1); VALUE is 0))).

        check_left_continues(BOARD,_,I,VALUE):-
            V is I - 1,
            ((V < 1,VALUE is 0);(nth1(V,BOARD,AUX),((var(AUX),VALUE = AUX);(AUX =:= 1,VALUE is 1);VALUE is 0))).


/***************retrição vertical********/
vertical_restrictions(_,SIZE,_,SIZE).
vertical_restrictions(BOARD,SIZE,VERTICAL,ROW):-
    nth1(ROW,VERTICAL,VAR),NewROW is ROW + 1,
    ((var(VAR),vertical_restrictions(BOARD,SIZE,VERTICAL,NewROW));
    (vertical_aux(BOARD,SIZE,ROW,LIST,SIZE),sum(LIST,#=,VAR),vertical_restrictions(BOARD,SIZE,VERTICAL,NewROW));
    true).

vertical_aux(BOARD,SIZE,ROW,LIST,1):-
  V is SIZE * ROW,
  nth1(V,BOARD,ELEM),
  ((var(ELEM),append([],[ELEM],LIST));append([],[],LIST)).

vertical_aux(BOARD,SIZE,ROW,LIST,AUX):-
    NewAUX is AUX - 1,
    vertical_aux(BOARD,SIZE,ROW,LIST_AUX,NewAUX),
    V is SIZE * ROW - (AUX - 1),
    nth1(V,BOARD,ELEM),
    ((var(ELEM),append(LIST_AUX,[ELEM],LIST));(append(LIST_AUX,[],LIST))).


/***************retrição vertical********/
horizontal_restrictions(_,SIZE,_,SIZE).
horizontal_restrictions(BOARD,SIZE,HORIZONTAL,COL):-
    nth1(COL,HORIZONTAL,VAR),NewCOL is COL + 1,
    ((var(VAR),horizontal_restrictions(BOARD,SIZE,HORIZONTAL,NewCOL));
    (horizontal_aux(BOARD,SIZE,COL,LIST,SIZE),sum(LIST,#=,VAR),horizontal_restrictions(BOARD,SIZE,HORIZONTAL,NewCOL));
    true).

horizontal_aux(BOARD,_,COL,LIST,1):-
  nth1(COL,BOARD,ELEM),((var(ELEM),append([],[ELEM],LIST));append([],[],LIST)).

horizontal_aux(BOARD,SIZE,COL,LIST,AUX):-
    NewAUX is AUX - 1,
    horizontal_aux(BOARD,SIZE,COL,LIST_AUX,NewAUX),
    V is COL + SIZE * (AUX -1),
    nth1(V,BOARD,ELEM),
    ((var(ELEM),append(LIST_AUX,[ELEM],LIST));(append(LIST_AUX,[],LIST))).




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
