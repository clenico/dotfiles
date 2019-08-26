#!/usr/bin/env bash

# dir_child_sym_link is finally unused, but could be usefull in the future, that's why i kept it
dir_child_sym_link(){
    if [ "$1" ]; then
        source_directory=$(realpath $1)
    else
        source_directory=$(realpath .)
    fi

    if [ "$2" ]; then
        destination_directory=$(realpath $2)
    else
        destination_directory=$HOME
    fi
    echo "Source : $source_directory -> dest :  $destination_directory"

    directories=$(ls $source_directory)

    for directory in ${directories[@]}; do
        link_destination="$destination_directory/$directory"
        echo $link_destination
        if [ -L $link_destination ];then
            echo "$link_destination already exists"
        else
            link_source="$source_directory/$directory"
            ln -s $link_source $link_destination
            echo "link_source -> $link_destination created"
        fi
    done
}

# Check if the argument is given, if not set default value
if [ "$1" ]; then
    source_directory=$(realpath $1)
else
    source_directory=$(realpath .)
fi

# Check if the argument is given, if not set default value
if [ "$2" ]; then
    destination_directory=$(realpath $2)
else
    destination_directory=$HOME
fi

# List All the directories in Source Directory E.G. ~/.clouds
# In order to work, the directory should be organised like: ~/.clouds/NameShortcut/Path/to/folder
# Proceed accordingly for each one of the usecase
clouds=$(ls $source_directory)

for cloud in ${clouds[@]}; do
    case $cloud in
        "Dropbox")
            source_dropbox=$source_directory"/"Dropbox
            directories=$(ls $source_dropbox)
            for directory in ${directories[@]}; do
                source_dropbox_instance=$source_dropbox"/"$directory"/Dropbox"
                destination_dropbox_instance=$destination_directory"/"$directory
                if [ -L $destination_dropbox_instance ];then
                    echo "$destination_dropbox_instance already exists"
                else
                    ln -s $source_dropbox_instance $destination_dropbox_instance
                    echo "$source_dropbox_instance -> $destination_dropbox_instance created"
                fi
            done
            ;;
        *)
            echo $"default"
            exit 1
    esac

done


# dir=default_dir file=default_file verbose_level=0
# while getopts d:f:v o; do
#   case $o in
#     (f) file=$OPTARG;;
#     (d) dir=$OPTARG;;
#     (v) verbose_level=$((verbose_level + 1));;
#     (*) usage
#   esac
# done
# shift "$((OPTIND - 1))"

# echo Remaining arguments: "$@"
