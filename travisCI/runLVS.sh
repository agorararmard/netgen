#!/bin/bash
# Copyright 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
export PDK_ROOT=$(pwd)/pdks
export RUN_ROOT=$(pwd)
echo $PDK_ROOT
echo $RUN_ROOT

docker run -it -v $RUN_ROOT:/netgen_root -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -e DESIGN=$DESIGN -u $(id -u $USER):$(id -g $USER) netgen:latest bash -c "tclsh ./travisCI/runLVS.tcl"

test_dir=$RUN_ROOT/testcases/designs/$DESIGN/test/lvs
TEST=$test_dir/lvs_final_parsed.log
BENCHMARK=$RUN_ROOT/testcases/designs/$DESIGN/benchmark/$DESIGN.lvs_parsed.log

crashSignal=$(find $TEST)
if ! [[ $crashSignal ]]; then echo "lvs check failed"; exit -1; fi

echo "Current Report Summary:"
cat $TEST
echo "Difference With Benchmark:"
diff -s $TEST $BENCHMARK

testSignal=$(diff -s $TEST $BENCHMARK | grep "identical" | wc -l)
if ! [[ $testSignal ]]; then testSignal=-1; fi

if [ $testSignal -ne 1 ]; then echo "Differences Exist between the two files"; exit -1; fi

exit 0
