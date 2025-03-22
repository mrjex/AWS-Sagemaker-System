#####     SHELL TESTS     #####

#   - Randomizes X distinct numbers between 1-150. Each number represents a row of '/data/iris.data'.
#     Each row has the data necessary to validate the type of flower. Thus, accessing the X:th row
#     allows for the AWS API to send a response that either validates or invalidates the Machine
#     Learning model's prediction of the corresponding type of flower. In other words, the X:th
#     row is equivalent to the provided request body in the POST method. All of this is automated
#     in this script.


source ./data-manager.sh


##  VARIABLE CONFIGURATION SECTION  ##

# Define the range of the rows to be tested in the dataset files
MIN_ROW=1
MAX_ROW=150

# The quantity of rows to test
NUM_OUTPUT=3



##  FUNCTION DEFINITION SECTION  ##


getRandomRangeNumbers() {
    OUTPUT=$(shuf -i "${MIN_ROW}-${MAX_ROW}" -n "${NUM_OUTPUT}")
    echo "${OUTPUT}"
}


testDataset() {
    readarray -t SPLIT_ARR <<<"${RANDOMIZED_NUMBERS_ARRAY}"

    for CURRENT_ROW_NUM in "${SPLIT_ARR[@]}"
    do
        echo "Processing row ${CURRENT_ROW_NUM}..."
        CURRENT_ROW_DATA=$(accessRowData "${CURRENT_ROW_NUM}")
        ROW_VALUES=(${CURRENT_ROW_DATA//,/ })

        appendJsonObjectROW "${ROW_VALUES[0]}" "${ROW_VALUES[1]}" "${ROW_VALUES[2]}" "${ROW_VALUES[3]}" "${CURRENT_ROW_NUM}"

        FLOWER_TYPE="${ROW_VALUES[4]}"
        postRequest "${CURRENT_REQ_FILE}" "${FLOWER_TYPE}"
    done
}




##  MAIN EXECUTION  ##

RANDOMIZED_NUMBERS_ARRAY=$(getRandomRangeNumbers "${MIN_ROW}" "${MAX_ROW}" "${NUM_OUTPUT}")
testDataset "${RANDOMIZED_NUMBERS_ARRAY}"