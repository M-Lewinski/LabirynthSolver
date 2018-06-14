open LabType

let findStartsEnds lab_fields height width =
    let starts = ref [] in
    let ends = ref [] in
        for i = 0 to height-1 do
            for j = 0 to width-1 do
                match lab_fields.(j).(i) with
                | Start x -> starts := (!starts)@[x]
                | End x -> ends := (!ends)@[x]
                | _ -> ()
            done;
        done;
    !starts, !ends;;


let isPath labField =
    match labField with
        | Path -> true
        | _ -> false;;

let fieldOrNothing lab x y =
    match (x>=0 && y>=0 && x<lab.width && y<lab.height) with
    | true -> lab.fields.(x).(y)
    | false -> Nothing;;

let isCross lab baseX baseY =
    let isCorner lab bX bY dX dY =
        (isPath (fieldOrNothing lab (bX+dX) bY)) && (isPath (fieldOrNothing lab bX (bY+dY)))
    in
        (isPath lab.fields.(baseX).(baseY)) &&
        (isCorner lab baseX baseY (-1) 1 ||
         isCorner lab baseX baseY (-1) (-1) ||
         isCorner lab baseX baseY 1 (-1) ||
         isCorner lab baseX baseY 1 1
        );;


let findAllNextCross lab node =
    let findNextCross lab (baseX, baseY) dX dY =
        let rec goToCross lab bX bY dX dY =
            match (fieldOrNothing lab bX bY) with
            | Path  -> goToCross lab (bX+dX) (bY+dY) dX dY
            | Cross x -> [x]
            | End x -> [x]
            | _ -> []
        in goToCross lab (baseX+dX) (baseY+dY) dX dY
    in
    node.next@
    (findNextCross lab node.nodePos (-1) (0))@
    (findNextCross lab node.nodePos (1) (0))@
    (findNextCross lab node.nodePos (0) (-1))@
    (findNextCross lab node.nodePos (0) (1));;


let loadLabirynth fine_name =
    let file = open_in fine_name in
    try
        let wdth = int_of_string (input_line file) in
        let hght = int_of_string (input_line file) in
        let lab_fields = Array.make_matrix wdth hght Nothing in
            for i = 0 to hght-1 do
                let line = input_line file in
                for j = 0 to wdth-1 do
                    match line.[j] with
                    | '-' -> lab_fields.(j).(i) <- Wall
                    | 'S' -> lab_fields.(j).(i) <- Start {
                            nodePos=(j,i);
                            nodeType=Start;
                            next=[];
                            visited=false;
                        }
                    | '0' when j==0 || i == 0 || j==wdth-1 || i=hght-1 -> lab_fields.(j).(i) <- End {
                            nodePos=(j,i);
                            nodeType=End;
                            next=[];
                            visited=false;
                        }
                    | '0' -> lab_fields.(j).(i) <- Path
                    | x -> raise (InvalidFile (Printf.sprintf "Labirynth contains invalid character %c" x));
                done;
                if i == hght-1 then close_in file;
            done;
        let starts, ends = findStartsEnds lab_fields hght wdth in
        {
            fields=lab_fields;
            width=wdth;
            height=hght;
            ends=ends;
            starts=starts;
        }
    with e ->
        Printf.printf("Invalid file format!!!\n\n");
        close_in file;
        raise e;;

let validateLabirynth lab =
    List.length lab.starts == 1 && List.length lab.ends >=1;;


let findAllCross lab =
    for i = 0 to lab.height-1 do
        for j = 0 to lab.width-1 do
            let checkType x =
                match (isCross lab j i) with
                | true -> Cross {
                        nodePos=(j,i);
                        nodeType=Cross;
                        next=[];
                        visited=false;
                    }
                | false -> x
            in lab.fields.(j).(i) <- (checkType lab.fields.(j).(i));
        done;
    done;
    lab;;

let getX (posX, _) = posX
let getY (_, posY) = posY

let getStart list =
    match list with
        | [x] -> x
        | _ -> raise (InvalidFile "xxx");;

let buildGraph lab =
    for i = 0 to lab.height-1 do
        for j = 0 to lab.width-1 do
                match lab.fields.(j).(i) with
                | Cross x -> x.next <- (findAllNextCross lab x)
                | Start x -> x.next <- (findAllNextCross lab x)
                | _ -> ()
        done;
    done;
    lab;;


let printLabNode node =
    let printPos (x,y) =
        ("("^(string_of_int x)^", "^(string_of_int y)^")")
    in printPos node.nodePos;;

let nodeListToStr list =
  let rec string_of_list list =
    match list with
      | [] -> ""
      | [x] -> printLabNode x
      | h::tail -> (printLabNode h)^";"^(string_of_list tail)
      in
        ("["^(string_of_list list)^"]");;

let printNodeGraph first =
    let rec print nodeL =
        match nodeL with
            | [] -> ""
            | [x] -> printLabNode x
            | h::t -> printLabNode h^" | "^print t
    in printLabNode first^" -> "^print first.next;;


let printLabirynth lab =
    Printf.printf "Lab width: %d\n" lab.width;
    Printf.printf "Lab height: %d\n" lab.height;
    Printf.printf "Start: %s\n" (nodeListToStr lab.starts);
    Printf.printf "Exits: %s\n" (nodeListToStr lab.ends);
    for i = 0 to lab.height-1 do
        for j = 0 to lab.width-1 do
            let checkType x =
                match x with
                | Start _ -> "\x1b[30m\x1b[42mST"
                | End _ -> "\x1b[30m\x1b[42mEX"
                | Cross _ -> "\x1b[30m\x1b[42m{}"
                | Wall -> "\x1b[31m\x1b[41m▮▮"
                | Path -> "\x1b[32m\x1b[42m▯▯"
                |  _ -> " "
            in Printf.printf "%s" (checkType lab.fields.(j).(i));
        done;
        Printf.printf "\x1b[0m\n";
    done;

    for i = 0 to lab.height-1 do
        for j = 0 to lab.width-1 do
                match lab.fields.(j).(i) with
                | Cross x -> Printf.printf "%s\n" (printNodeGraph x)
                | Start x -> Printf.printf "%s\n" (printNodeGraph x)
                | _ -> ()
        done;
    done;;


let solveLab lab =
    let rec goNext node =
        let rec goToNexts list =
            match list with
                | h :: t when h.visited == false -> goNext h
        in goToNexts node.next
    in goNext (getStart lab.starts)
    lab;;