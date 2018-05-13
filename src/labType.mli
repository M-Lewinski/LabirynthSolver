type labField =
    | Start of int
    | End of int
    | Path of int
    | Wall of int;;

type labirynth = {
    fields: labField array array;
    width: int;
    height: int;
    };;