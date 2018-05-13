open LabType

let loadLabirynth fine_name =

    let file = open_in fine_name in
    try
        let wdth = int_of_string (input_line file) in wdth;
        let hght = int_of_string (input_line file) in hght;

        Printf.printf "\tLab width: \t%d\n" wdth;
        Printf.printf "\tLab height: \t%d\n" hght;

        let lab_fields = Array.make_matrix wdth hght (Wall 0) in
            for i = 0 to hght-1 do
                let line = input_line file in line;

                (* TODO explode line and match character *)
                for j = 0 to wdth-1 do
                    lab_fields.(j).(i) = End 0;
                done;


                if i == hght-1 then close_in file;
            done;
            lab_fields;
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
    Printf.printf "lab";;