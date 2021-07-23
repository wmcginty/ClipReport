#Helper Functions
is_variant_name() {
  if [[ $1 == Variant:* ]]; then
    return 0
  else
    return 1
  fi
}

is_variant_descriptors() {
  if $2 && [[ $1 == *"variant descriptors"* ]]; then
    return 0
  else
    return 1
  fi
}

is_size_description() {
  if [[ $1 == *"size"* ]]; then
    if $2 || [[ $1 != *"On Demand"* ]]; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

#Main Processing Script
include_supported_descriptors=${2:-false}
include_on_demand_resources=${3:-false}

output_message=""
while IFS= read -r line; do

  # Find the title of the App Thinning Report
  if [ -z "$output_message" ]; then
    output_message+=$line

  # If the line is empty, leave it empty
  elif [ -z "$line" ]; then
    output_message+="\n"

  # Find the variant name
  elif is_variant_name "$line"; then
    output_message+="\n$line"

  # Find the variant descriptors when needed
  elif is_variant_descriptors "$line" $include_supported_descriptors; then
    output_message+="\n$line"

  # Find the size information, including ODRs when needed
  elif is_size_description "$line" $include_on_demand_resources; then
    output_message+="\n$line"
  fi

done < "$1"


echo $output_message
