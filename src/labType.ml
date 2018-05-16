type labField =
    | Nothing
    | Start
    | End
    | Path
    | Wall;;

type labirynth = {
    fields: labField array array;
    width: int;
    height: int;
    };;