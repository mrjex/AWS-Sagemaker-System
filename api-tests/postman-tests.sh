#####     POSTMAN TESTS     #####

#   - This script is intended to run all of the tests from 'postman-tests.json'. Of course,
#     you as a developer can import the JSON file and run them via Postman's UI, however,
#     this script serves the purpose of automating that process with one command


source ./data-manager.sh

FILE="postman-tests.json"
LAST_TEST_IDX=5


runTests() {
    for i in $(seq 0 $LAST_TEST_IDX);
    do
        REQ_BODY=$(getJsonValue "${FILE}" "item[${i}].request.body.raw")
        formatData "${REQ_BODY}" "${i}"
        
        postRequest "${CURRENT_REQ_FILE}" "${FLOWER_TYPE}"
    done
}



# Function:
#   - Parses the retrieved string-value from 'postman-tests.json',
#     formats it into a valid JSON structure and writes it in
#     'current-req-body.json'
#
# Arguments:
#   - REQ_BODY:         The initial string to be parsed
#   - ARG2:             The index of the currently examined Postman test
#
formatData() {
    MANIPULATED_STRING=$(echo "${REQ_BODY}" | awk NF RS='[""]')     # Replace first and last characters of '"'
    CURRENT_JSON_BODY=$(tr "'" '\"' <<<"${MANIPULATED_STRING}")     # Replace all ' with "

    echo "${CURRENT_JSON_BODY}" > "${CURRENT_REQ_FILE}"
    FLOWER_TYPE=$(cat current-req-body.json | python -c 'import json,sys;obj=json.load(sys.stdin);print(obj["flower-type"])')

    appendJsonObjectPOSTMAN "${CURRENT_JSON_BODY}" "${2}"
}


runTests