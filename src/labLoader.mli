open LabType

(* loadLabirynth loads larynth from file and returns 2 dim array of type labField *)
val loadLabirynth: string -> labirynth
(* validateLabirynth chacks if labirynth is valid (contains start and end ) *)
val validateLabirynth: labirynth -> bool
val printLabirynth: labirynth -> unit

val findAllCross: labirynth -> labirynth
val buildGraph: labirynth -> labirynth
val solveLab: labirynth -> labNode list
val printSolution: labNode list -> unit
val drawSolution: labirynth -> labNode list -> labirynth