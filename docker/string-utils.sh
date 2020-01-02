#!/bin/ash
remove_substring_from_last(){
    main_string=$1
    string_to_remove=$2
    length_substring=$(length $string_to_remove)
    length_main_string=$(length $main_string)

    length_resulted_string=$length_main_string-$length_substring
    echo ${main_string:0:$length_resulted_string}
}

length(){
    string=$1
    echo ${#string}
}

substring_index(){
    main_string=$1
    sub_string=$2
    echo `expr index $main_string $sub_string`
}

split_string() {
  echo "$1" | split_input "$2"
}

sub_string() {
  main_string=$1
  index=$2
  echo "${line:start_index_property_value}"
}

split_input() {
  local sep="${1:-$' \t'}"
  tr "$sep" '\n'                    |
  sed -Ee 's/^(.*[ ,?*].*)$/"\1"/'  |
  tr '\n' ' '
}

ltrim() {
 str=$1
 echo `echo $str | sed -e 's/^[[:space:]]*//'`
}

rtrim() {
 str=$1
 echo `echo $str | sed -e 's/[[:space:]]$*//'`
}

trim() {
 str=$1
 echo `echo $str | sed -Ee 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
}