#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counter for failed tests
FAILED_TESTS=0

# Number of tests to run, can be increased as needed
TESTS_TO_RUN=1231

# Main loop for running tests
for i in fileTests/inFiles/test*.in; do
    testNumber=${i//[^0-9]/} # Extracting test number from filename

    if [[ $testNumber -gt $TESTS_TO_RUN ]]; then
        continue
    fi

    echo "Running test $testNumber >>>"

    # Run the game simulation and output results to a file
    ./FileTester "fileTests/inFiles/test${testNumber}.deck" "$i" "fileTests/outFiles/test${testNumber}.result"

    # Compare the generated result with the expected result
    if diff "fileTests/outFiles/test${testNumber}.out" "fileTests/outFiles/test${testNumber}.result" > /dev/null; then
        echo -e "Game Simulation: ${GREEN}pass${NC},"
    else
        echo -e "Game Simulation: ${RED}fail${NC},"
        ((FAILED_TESTS++))
    fi

    # Run Valgrind to check for memory leaks
    valgrindLogFile="fileTests/inFiles/test${testNumber}.valgrind_log"
    valgrind --log-file="$valgrindLogFile" --leak-check=full ./FileTester "$i" "fileTests/inFiles/test${testNumber}.deck" "fileTests/outFiles/test${testNumber}.vresult" > /dev/null 2>&1

    # Clean up the Valgrind result file as it's no longer needed
    rm -f "fileTests/outFiles/test${testNumber}.vresult"

    # Check Valgrind's output for the absence of memory leaks
    if grep -q "ERROR SUMMARY: 0 errors" "$valgrindLogFile"; then
        echo -e "Memory Leak: ${GREEN}pass${NC}\n"
    else
        echo -e "Memory Leak: ${RED}fail${NC}\n"
        cat "$valgrindLogFile"
        ((FAILED_TESTS++))
    fi

    # Remove Valgrind log file after checking
    rm -f "$valgrindLogFile"
done

# Final output, showing whether all tests passed or some failed
if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed :)\n\n${NC}"
else
    echo -e "\n${RED}Failed $FAILED_TESTS tests.\n\n${NC}"
fi
echo "Increase TESTS_TO_RUN in tester.sh to run more tests (up to 4030)."
