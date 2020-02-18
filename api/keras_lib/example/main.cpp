#include <iostream>

#include "../src/keras.h"

#define KR_CHECK(A) A

using namespace std;

int main()
{
  KR_CHECK(createModel());
  KR_CHECK(addInput("Input", "C1"));
  return 0;
}
