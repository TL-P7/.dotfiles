local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
return {
  s("check", fmt([[
#!/bin/bash

GEN="gen.cpp"
SOL="sol.cpp"
STD="std.cpp"

infile="in.txt"
errfile="err.txt"
solOutfile="solout.txt"
stdOutfile="stdout.txt"

maxGentime="2s"
maxRuntime="2s"

cppCompile() {
    g++ "$1" -O2 -Wall -o "${1%.*}"
    if [ $? -ne 0 ]; then
        echo "$1 Compilation error"
        exit 0
    fi
    echo "Compiled $1"
}

cppRunGen() {
    timeout $maxGentime ./"${1%.*}" > $infile
    if [ $? -eq 124 ]; then
        echo "$1 Time limit exceeded"
        cat $infile > $errfile
        echo "Input saved as $errfile"
        exit 0
    fi
}

cppRun() {
    timeout $maxRuntime ./"${1%.*}" < $infile > "$2"
    if [ $? -eq 124 ]; then
        echo "$1 Time limit exceeded"
        cat $infile > $errfile
        echo "Input saved as $errfile"
        exit 0
    fi
}

cppCompile $GEN
cppCompile $SOL
cppCompile $STD

cnt=0
while true; do
    cnt=$((cnt+1))

    cppRunGen $GEN
    cppRun $SOL $solOutfile
    cppRun $STD $stdOutfile

    printf "Test %d" $cnt
    if diff -Z $stdOutfile $solOutfile > /dev/null; then
        echo " AC"
    else
        echo " WA"
        cat $infile > $errfile
        echo "Input saved as $errfile"
        exit 0
    fi
done
    ]], {}, { delimiters = "@&" })),

}
