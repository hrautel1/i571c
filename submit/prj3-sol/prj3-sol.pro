employees([employee(tom,33,cs,85000.0),employee(joan,23,ece,110000.0),employee(bill,29,cs,69500.0),employee(john,28,me,58200.0),employee(sue,19,cs,22000.0)]).

%1
employee(tom,33,cs,85000.0).
employee(joan,23,ece,110000.0).
employee(bill,29,cs,69500.0).
employee(john,28,me,58200.0).
employee(sue,19,cs,22000.0).
dept_employees([], Dept, []).
dept_employees([Employees|T], Dept, DeptEmployees) :-
    findall(employee(A, B, Dept, D), employee(A, B, Dept, D), DeptEmployees).

:-begin_tests(dept_employees, []).
test(dept_employees_cs, all(Zs =
		[[employee(tom, 33, cs, 85000.00),
				employee(bill, 29, cs, 69500.00),
				employee(sue, 19, cs, 22000.00)
			]])) :-
    employees(E),
    dept_employees(E, cs, Zs).
test(dept_employees_ece, all(Zs = [[employee(joan, 23, ece, 110000.00)]])) :-
    employees(E),
    dept_employees(E, ece, Zs).

test(dept_employees_ce, all(Zs= [[]])) :-
    employees(E),
    dept_employees_(E, ce, Zs).
:-end_tests(dept_employees).

%2
employees_salary_sum(Employees, Sum) :-
    employees_salary1_sum(Employees, 0, Sum).
employees_salary1_sum([], Sum, Sum).
employees_salary1_sum([employee(_, _, _, S)|Ts], Acc, Sum) :-
    Acc1 is Acc + S,
    employees_salary1_sum(Ts, Acc1, Sum).

:-begin_tests(employees_salary_sum).
test(empty) :-
    employees_salary_sum([], 0).
test(seq_salaries) :-
    Employees = [
    employee(_, _, _, 1),
    employee(_, _, _, 2),
    employee(_, _, _, 3),
    employee(_, _, _, 4),
    employee(_, _, _, 5)
    ],
    employees_salary_sum(Employees, 15).
test(all) :-
    employees(Employees),
    employees_salary_sum(Employees, 344700.00).
:-end_tests(employees_salary_sum).

%3
list_access([Head|Tail], List, Z) :-
    nth0(Head, List, E),
    list_access(Tail, E, Z).
list_access([], List, Z) :-
    Z = List.
list_access([Head|_], List, Z) :-
    not(nth0(Head, List, _)),
    Z = nil.

:- begin_tests(list_access).
test(index_1, all(Z = [b])) :-
    list_access([1], [a, b, c], Z).
test(index_2, all(Z = [[c]])) :-
    list_access([2], [a, b, [c]], Z).
test(index_2_0, all(Z = [c])) :-
    list_access([2, 0], [a, b, [c]], Z).
test(index_2_1, all(Z = [nil])) :-
    list_access([2, 1], [a, b, [c]], Z).
test(index_3, all(Z = [nil])) :-
    list_access([3], [a, b, [c]], Z).
test(index_2_1, all(Z = [nil])) :-
    list_access([3], [a, b, [c]], Z).
test(index_empty, all(Z = [X])) :-
    X = [[1, 2, 3], [4, [5, 6, [8]]]],
    list_access([], X, Z).
test(index_and_list_empty, all(Z = [[]])) :-
    list_access([], [], Z).
test(list_empty, all(Z = [nil])) :-
    list_access([1], [], Z).
test(index_1_1_2, all(Z = [[8]])) :-
    X = [[1, 2, 3], [4, [5, 6, [8]]]],
    list_access([1, 1, 2], X, Z).
test(index_1_1_2_0, all(Z = [8])) :-
    X = [[1, 2, 3], [4, [5, 6, [8]]]],
    list_access([1, 1, 2, 0], X, Z).
test(index_0_1, all(Z = [nil])) :-
    list_access([0, 1], [[1]], Z).
:- end_tests(list_access).

%4
count_non_pairs([], 1).
count_non_pairs(D, 1) :- D \= [_|_].
count_non_pairs([X|L], NNonPairs) :-
    count_non_pairs(L, NNPair),
    count_non_pairs(X, NNPairr),
    NNonPairs is NNPair + NNPairr.

:- begin_tests(count_non_pairs).
test(empty, nondet) :-
    count_non_pairs([], 1).
test(unary_list, nondet) :-
    count_non_pairs([1], 2).
test(simple_list, nondet) :-
    count_non_pairs([1, 2, [], a, []], 6).
test(nested_list, nondet) :-
    count_non_pairs([[1, 2, 3], [[a], b, []]], 10).
test(nested_list_fail, fail) :-
    count_non_pairs([[1, 2, 3], [[a], b]], 10).
test(complex, nondet) :-
    count_non_pairs([[1, f([a, b, c]), h(1)], [[a], b]], 9).
test(complex_fail, fail) :-
    count_non_pairs([[1, f([a, b, c]), h(1)], [[a], b]], 8).
:- end_tests(count_non_pairs).

%5
divisible_by([], _, []).
divisible_by([X|Xs], Y, [X|T]) :-
    X mod Y =:= 0,
    divisible_by(Xs, Y, T).
divisible_by([X|Xs], Y, T) :-
    X mod Y =\= 0,
    divisible_by(Xs, Y, T).

:- begin_tests(divisible_by).
test(empty, fail) :-
    divisible_by([], 2, _).
test(divisible_by_2, all(Int=[4, -8])) :-
    divisible_by([4, 7, -9, -8], 2, Int).
test(divisible_by_5, all(Int=[15, -25, 5])) :-
    divisible_by([4, 15, -25, -22, 5], 5, Int).
test(none_divisible_by_3, fail) :-
    divisible_by([4, 16, -25, -22, 5], 3, _Int).
:- end_tests(divisible_by).

%6
re_match(empty, []).

re_match(P, [L]) :-
     P == L.

re_match(conc(P, L), Z) :-
    append(Z1, Z2, Z),
    re_match(P, Z1),
    re_match(L, Z2).

re_match(alt(P, _), Z) :-
    re_match(P, Z).

re_match(alt(_, L), Z) :-
    re_match(L, Z).

re_match(kleene(P), Z) :-
    append([Car|Z1], Z2, Z),
    re_match(P, [Car|Z1]),
    re_match(kleene(P), Z2).

re_match(kleene(_),[]).

:- begin_tests(re_match).
test(single) :-
    re_match(a, [a]).
test(single_fail, fail) :-
    re_match(a, [b]).
test(conc) :-
    re_match(conc(a, b), [a, b]).
test(conc_fail, fail) :-
    re_match(conc(a, b), [a, c]).
test(alt1, nondet) :-
    re_match(alt(a, b), [a]).
test(alt2, nondet) :-
    re_match(alt(a, b), [b]).
test(alt_fail, fail) :-
    re_match(alt(a, b), [c]).
test(kleene_empty, nondet) :-
    re_match(kleene(a), []).
test(kleene_single, nondet) :-
    re_match(kleene(a), [a]).
test(kleene_multiple, nondet) :-
    re_match(kleene(a), [a, a, a, a]).
test(conc_kleene_sym, nondet) :-
    re_match(conc(kleene(a), b), [a, a, a, a, b]).
test(kleene_kleene0, nondet) :-
    re_match(conc(kleene(a), kleene(b)), [a, a, a, a]).
test(kleene_kleene, nondet) :-
    re_match(conc(kleene(a), kleene(b)), [a, a, a, a, b, b, b]).
test(kleene_kleene_fail, fail) :-
    re_match(conc(kleene(a), kleene(b)), [a, a, a, a, b, b, b, a]).
test(kleene_conc, nondet) :-
    re_match(kleene(conc(a, b)), [a, b, a, b, a, b]).
test(kleene_conc_fail, fail) :-
    re_match(kleene(conc(a, b)), [a, b, a, b, a, b, a]).
test(kleene_alt, nondet) :-
    re_match(kleene(alt(a, b)), [a, a, b, a, b, a, b, b]).
test(conc_kleene_conc, nondet) :-
    re_match(conc(a, conc(kleene(b), a)), [a, b, b, b, a]).
test(conc_kleene0_conc, nondet) :-
    re_match(conc(a, conc(kleene(b), a)), [a, a]).
test(conc_kleene_conc_fail, fail) :-
    re_match(conc(a, conc(kleene(b), a)), [a, b, b, b]).
test(complex1, nondet) :-
    re_match(conc(kleene(alt(a, b)), kleene(alt(0, 1))), [a,b,b,a,0,0,1,1]).
test(complex2, nondet) :-
    re_match(conc(kleene(alt(a, b)), kleene(alt(0, 1))), [0,0,1,1]).
test(complex_empty, nondet) :-
    re_match(conc(kleene(alt(a, b)), kleene(alt(0, 1))), []).
:- end_tests(re_match).


%7
:- op(200, fx, ~).
clausal_form([], Accu, Accu).
clausal_form([W|Ws], Accu, Z) :-
    clause_format(W, Z1),
    clausal_form(Ws, Accu /\ Z1, Z).

clausal_form([W|Ws], Z) :-
    clause_format(W, Z1),
    clausal_form(Ws, Z1, Z).

predicate_rule(L, D, D) :-
    L \= (G,F).
predicate_rule(L, Acc, D) :-
    L = (G,F),
    C = Acc /\ G /\ F,
    predicate_rule_body(F, C, D).
predicate_rule_body(L, Acc, D) :-
    L = (G,F),
    C = Acc \/ ~G \/ ~F,
    predicate_rule_body(F, C, D).
predicate_rule_body(L, D, D) :-
    L \= (G,F).

clause_format(W, D) :-
    W = (P:-L),
    L = (G,F),
    predicate_rule_body(F,P \/ ~G, D).
clause_format(W, D) :-
    W = (P,L),
    predicate_rule(L,P,D).
clause_format(W, W) :-
    W \= (P:-L),
    W \= (P,L).
clause_format(W, P \/ ~L) :-
    W = (P:-L),
    L \= (G,F).

:- begin_tests(clausal_form).
test(single_head, all(Z = [p(a, b)])) :-
    clausal_form([p(a, b)], Z).
test(simple_rule, all(Z = [p(a, b) \/ ~q(a, b)])) :-
    clausal_form([(p(a, b) :- q(a, b))], Z).
test(rule_with_multi_body,
     all(Z = [p(a, b) \/ ~q(a, b) \/ ~r(a, b) \/ ~s(x)])) :-
    clausal_form([(p(a, b) :- q(a, b), r(a, b), s(x))], Z).
test(multi_rule, all(Z = [p(a, b) /\ q(x, y) /\ r(1)])) :-
    clausal_form([p(a, b), q(x, y), r(1)], Z).
test(complex, all(Z = [Clause1 /\ Clause2 /\ Clause3 /\ Clause4])) :-
    Rule1 = (p(a, b) :- q(b, c), r(a, b), s(x)),
    Clause1 = p(a, b) \/ ~q(b, c) \/ ~r(a, b) \/ ~s(x),
    Rule2 = (m(f(X)) :- n(f(X), Y), X is 2*Y),
    Clause2 = m(f(X)) \/ ~n(f(X), Y) \/ ~(X is 2*Y),
    Rule3 = append([], Xs, Xs),
    Clause3 = append([], Xs, Xs),
    Rule4 = (append([A|As], Ys, [A|Zs]) :- append(As, Ys, Zs)),
    Clause4 = append([A|As], Ys, [A|Zs]) \/ ~append(As, Ys, Zs),
    clausal_form([Rule1, Rule2, Rule3, Rule4], Z).
:- end_tests(clausal_form).
