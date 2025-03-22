#####     DATA MANAGER     #####

#   - The functional utility storage that is common for the contained operations
#     in 'shell-tests.sh' and 'postman-tests.sh'


###   VARIABLE CONFIGURATIONS SECTION   ###

##  FILES  ##
ARTIFACT_FILE="row-data.json"
CURRENT_REQ_FILE="current-req-body.json"
DATASET_FILE="../data/iris.data"

##  DATA MAPPING  ##
declare -A CLASS_MAPPING=(["Iris-setosa"]="0" ["Iris-virginica"]="1" ["Iris-versicolor"]="2")
AWS_GATEWAY_API="https://z9it6xnflj.execute-api.eu-north-1.amazonaws.com/dev"

##  COLORS  ##  
GREEN='\033[0;32m'
RED='\033[0;31m'
NO_COLOR='\033[0m'


# Wipes out all the content of the file that was generated in the previous execution
clearFile() {
    > ${1}
    echo "{}" > ${1}
}


# Function:
#   - Appends new data to a given JSON file
#   - Requires that the provided row-data is separated through the arguments
#
# Arguments:
#   - ARG1: x1
#   - ARG2: x2
#   - ARG3: x3
#   - ARG4: x4
#   - ARG5: Data row (1-150)
#
appendJsonObjectROW() {
    QUERY_OBJ="{\"x1\": ${1}, \"x2\": ${2}, \"x3\": ${3}, \"x4\": ${4}}"
    storeQueryObject "${QUERY_OBJ}"

    INFO_OBJ="{\"row${5}\": ${QUERY_OBJ}}"
    NEW_JSON_CONTENT=$(cat "${ARTIFACT_FILE}" | jq ". += ${INFO_OBJ}")

    echo "${NEW_JSON_CONTENT}" > "${ARTIFACT_FILE}"
}



# Function:
#   - Appends new data to a given JSON file
#   - Requires that the provided row-data is contained all in one argument
#
# Arguments:
#   - ARG1: Row values (x1, ... , x4)
#   - ARG2: The index of the Postman test
#
# Examples:
#   - Text
appendJsonObjectPOSTMAN() {
    QUERY_OBJ="${1}"
    storeQueryObject "${QUERY_OBJ}"

    INFO_OBJ="{\"Test${2}\": ${QUERY_OBJ}}"
    NEW_JSON_CONTENT=$(cat "${ARTIFACT_FILE}" | jq ". += ${INFO_OBJ}")

    echo "${NEW_JSON_CONTENT}" > "${ARTIFACT_FILE}"
}


# Writes to 'current-req-body.json' such that the addition of the most
# recent instance overrides the old content of the file
storeQueryObject() {
    echo "${QUERY_OBJ}" > "${CURRENT_REQ_FILE}"
}


# Function:
#   - Returns the desired group of data contained in a JSON file
#
# Arguments:
#   - ARG1: The file of structured data to access
#   - ARG2: The sequence of nested attributes attached to the desired data
#
# Examples:
#   - EX-1: cat "row-data.json" | jq '.row5'
#   - EX-2: cat "row-data.json" | jq '.row5.x1'
#
getJsonValue() {
    cat "${1}" | jq ".${2}"
}


# Function:
#   - Gets the i:th row of text in a given file
#
# Arguments:
#   - CURRENT_ROW_NUM:  The row number to access
#   - DATASET_FILE:     The file to enter
#
accessRowData() {
    sed -n "${CURRENT_ROW_NUM}p" < "${DATASET_FILE}"
}


###   FUNCTION DEFINITION SECTION   ###

# Function:
#   - Sends a POST request to the AWS Sagemaker API via Api Gateway
#
# Attributes:
#   - CURRENT_REQ_FILE:     The JSON file that the API reads as the request body
#   - FLOWER_TYPE:          The flower type
#
postRequest() {
    API_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -d "@${CURRENT_REQ_FILE}" https://z9it6xnflj.execute-api.eu-north-1.amazonaws.com/dev | jq -r '.prediction')

    printf "\n"
    EXPECTED_RESPONSE=${CLASS_MAPPING["${FLOWER_TYPE}"]}

    if [ "${API_RESPONSE}" == "${EXPECTED_RESPONSE}" ]
    then
        echo -e "${GREEN} CORRECT ${NO_COLOR}"
    else
        echo -e "${RED} INCORRECT ${NO_COLOR}"
    fi
    
    printf "\n"
}


##  MAIN EXECUTION  ##

clearFile "${ARTIFACT_FILE}"