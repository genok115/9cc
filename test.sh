#!/bin/bash
assert() {
  expected="$1"
  input="$2"

  ./9cc "$input" > tmp.s
  cc -o tmp tmp.s
  ./tmp
  actual="$?"

  if [ "$actual" = "$expected" ]; then
    echo "$input => $actual"
  else
    echo "$expected expected, but got $actual"
    exit 1
  fi
}

assertfail() {
  expected="$1"
  input="$2"

  echo "error expected with \"$input\""
  ./9cc "$input" > /dev/null

  if [ $? -eq 0 ]; then
    echo "error expected, but got succeeded."
    exit 1
  else 
    return 0;
  fi
}

assert 0 0
assert 42 42
assert 21 "5+20-4"
assert 2 "0 - 3 + 5"
assert 41 " 12 + 34 - 5 "
assertfail 4 "1+3++"
assertfail 6 "1 + foo + 5"
assert 15 "5*(9-6)"
assert 4 "(3+5)/2"
assert 47 "5+6*7"
assert 10 "-10+20"
assert 10 "- -10"
assert 10 "- - +10"

assert 0 "1==0"
assert 1 "1==1"
assert 1 "1!=0"
assert 0 "1!=1"
assert 1 "1>0"
assert 0 "1>1"
assert 0 "1>2"
assert 1 "1>=0"
assert 1 "1>=1"
assert 0 "1>=2"
assert 0 "1<0"
assert 0 "1<1"
assert 1 "1<2"
assert 0 "1<=0"
assert 1 "1<=1"
assert 1 "1<=2"

echo OK

