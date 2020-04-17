#include "workingmnist.h"
#include "workingbreast.h"
#include "workingwine.h"
#include "workingiris.h"
#include "workingfahrenheit.h"
#include "workingboston.h"
#include "workingbike.h"
#include "workingtitanic.h"

#define NN_MNIST

int main()
{
  int exitStatus = 0;
#if defined(NN_MNIST)
  exitStatus = mnist::workingMNIST(true);
#elif defined(NN_BREAST)
  exitStatus = breast::workingBreast(false);
#elif defined(NN_WINE)
  exitStatus = wine::workingWine(false);
#elif defined(NN_IRIS)
  exitStatus = iris::workingIris(false);
#elif defined(NN_FAH)
  exitStatus = fahrenheit::workingFahrenheit(false);
#elif defined(NN_BOSTON)
  exitStatus = boston::workingBoston(false);
#elif defined(NN_BIKE)
  exitStatus = bike::workingBike(false);
#elif defined(NN_TITANIC)
  exitStatus = titanic::workingTitanic(true);
#endif //NN_MNIST
  return exitStatus;
}
