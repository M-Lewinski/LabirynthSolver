exception InvalidFile of string;;

type labField =
    | Nothing
    | Start of int*int
    | End of int*int
    | Path of int*int
    | Wall of int*int;;

type labirynth = {
    fields: labField array array;
    width: int;
    height: int;
    starts: labField list;
    ends: labField list
    };;