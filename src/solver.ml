open LabLoader
open LabSolver
open Printf
open LabType


let input_file = "input.txt"
exception FileNotFound of string

let () =
  if Array.length Sys.argv < 2 then raise (FileNotFound "Missing input file name");

  printf "Loading input file: %s \n" Sys.argv.(1);
  let labirynth = loadLabirynth Sys.argv.(1) in
    printLabirynth labirynth;

  printf "Validating labirynth\n";
  if validateLabirynth labirynth != true then raise (InvalidFile "Labirynth is invalid.\n It must have 1 starting point and > 0 exit points");

  let labirynth = buildGraph (findAllCross labirynth) in
    printLabirynth labirynth;


  printf "Solving labirynth\n";
  let solution = solveLab labirynth in  printSolution solution;

  let labirynth = drawSolution labirynth solution in printLabirynth labirynth;
  printf "Labirynth solver\n";
