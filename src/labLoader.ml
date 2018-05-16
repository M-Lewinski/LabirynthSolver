open LabType

exception InvalidFile of string;;

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
                    | '0' -> lab_fields.(j).(i) <- Path
                    | 'S' -> lab_fields.(j).(i) <- Start
                    | 'E' -> lab_fields.(j).(i) <- End
                    | x -> raise (InvalidFile (Printf.sprintf "Labirynth contains invalid character %c" x));
                done;
                if i == hght-1 then close_in file;
            done;
        {
            fields=lab_fields;
            width=wdth;
            height=hght;
        }
    with e ->
        Printf.printf("Invalid file format!!!\n\n");
        close_in file;
        raise e;;

let validateLabirynth lab =
    let result = true in result;;

let printLabirynth lab =
    Printf.printf "Lab width: %d\n" lab.width;
    Printf.printf "Lab height: %d\n" lab.height;
    for i = 0 to lab.height-1 do
        for j = 0 to lab.width-1 do
            match lab.fields.(j).(i) with
            | Start -> Printf.printf "\x1b[30m\x1b[42mS"
            | End -> Printf.printf "\x1b[30m\x1b[42mE"
            | Wall -> Printf.printf "\x1b[31m\x1b[41m▮"
            | Path -> Printf.printf "\x1b[32m\x1b[42m▯"
            |  _ -> Printf.printf " ";
        done;
        Printf.printf "\x1b[0m\n";
    done;
    Printf.printf "lab";;