exception InvalidFile of string;;

type labFieldType =
    | Nothing
    | Start
    | End
    | Path
    | Wall;;

type labNode = {
    fieldPos: int * int;
    fieldType: labFieldType;
    next: labNode list;
    visited: bool;
}

type labirynth = {
    fields: labFieldType array array;
    width: int;
    height: int;
    starts: labNode list;
    ends: labNode list
    };;