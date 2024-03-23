#!/bin/bash

# Check if a test number was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <test_number>"
    exit 1
fi

# Extract the test number from the first argument
TEST_NUMBER=$1

# Define the paths to the expected output and the actual result files
EXPECTED_OUTPUT_PATH="fileTests/outFiles/test${TEST_NUMBER}.out"
ACTUAL_RESULT_PATH="fileTests/outFiles/test${TEST_NUMBER}.result"

# Check if the expected output file exists
if [ ! -f "$EXPECTED_OUTPUT_PATH" ]; then
    echo "Expected output file $EXPECTED_OUTPUT_PATH does not exist."
    exit 2
fi

# Check if the actual result file exists
if [ ! -f "$ACTUAL_RESULT_PATH" ]; then
    echo "Actual result file $ACTUAL_RESULT_PATH does not exist."
    exit 3
fi

# Use the diff command to show the differences between the expected output and the actual result
echo "Showing differences for test $TEST_NUMBER:"
DIFF_OUTPUT=$(diff -u --color=always "$EXPECTED_OUTPUT_PATH" "$ACTUAL_RESULT_PATH")

if [ -z "$DIFF_OUTPUT" ]; then
    echo "There are no differences."
else
    echo "$DIFF_OUTPUT"
fi
