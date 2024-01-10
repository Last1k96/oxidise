def ranger_cd [] {
    let temp_file = (mktemp)
    ranger --choosedir $temp_file
    
    let chosen_dir = (open $temp_file | get raw | str trim)

    if ($chosen_dir != "") and ($chosen_dir != (pwd)) {
        cd $chosen_dir
    }

    rm $temp_file
}
