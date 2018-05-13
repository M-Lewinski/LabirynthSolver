all: solver

labLoader:
	ocamlc -c labType.cmo ./src/labLoader.mli -o ./labLoader.cmi
	ocamlc -c labType.cmo ./src/labLoader.ml -o ./labLoader.cmo

labSolver:
	ocamlc -c ./src/labSolver.mli -o ./labSolver.cmi
	ocamlc -c ./src/labSolver.ml -o ./labSolver.cmo

labType:
	ocamlc -c ./src/labType.mli -o ./labType.cmi
	ocamlc -c ./src/labType.ml -o ./labType.cmo

solver: labType labLoader labSolver
	ocamlc -o solver labType.cmo labLoader.cmo labSolver.cmo src/solver.ml
	rm -r src/*.cmo src/*cmi

clean:
	rm -r *.cmo *cmi solver
