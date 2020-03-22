#include "workingmnist.h"
#include "workingbreast.h"
#include "workingwine.h"
#include "workingiris.h"
#include "workingfahrenheit.h"

#define NN_FAH

int main()
{
  int exitStatus = 0;
#if defined(NN_MNIST)
  exitStatus = workingMNIST(true);
#elif defined(NN_BREAST)
  exitStatus = breast::workingBreast(false);
#elif defined(NN_WINE)
  exitStatus = wine::workingWine(true);
#elif defined(NN_IRIS)
  exitStatus = iris::workingIris(false);
#elif defined(NN_FAH)
  exitStatus = fahrenheit::workingFahrenheit(false);
#endif //NN_MNIST
  return exitStatus;
}
