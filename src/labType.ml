exception InvalidFile of string;;

type labNodeType =
    | Start
    | End
    | Cross;;

type labNode = {
    nodePos: int * int;
    nodeType: labNodeType;
    mutable next: labNode list;
    visited: bool;
}

type labFieldType =
    | Nothing
    | Path
    | Wall
    | Cross of labNode
    | Start of labNode
    | End of labNode
    ;;

type labirynth = {
    fields: labFieldType array array;
    width: int;
    height: int;
    starts: labNode list;
    ends: labNode list
    };;