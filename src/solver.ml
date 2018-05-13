open LabLoader
open LabSolver
open Printf

let input_file = "input.txt"
exception FileNotFound of string

let () =
  if Array.length Sys.argv < 2 then raise (FileNotFound "Missing input file name");

  printf "Loading input file: %s \n" Sys.argv.(1);
  let labirynth = loadLabirynth Sys.argv.(1) in labirynth;

  printf "Validating labirynth\n";

  printf "Solving labirynth\n";

  printf "Labirynth solver\n";
