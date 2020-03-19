#include "workingmnist.h"
#include "workingbreast.h"

#define NN_BREAST

int main()
{
  int exitStatus = 0;
#if defined(NN_MNIST)
  exitStatus = workingMNIST(true);
#elif defined(NN_BREAST)
  exitStatus = workingBreast(false);
#endif //NN_MNIST
  return exitStatus;
}
