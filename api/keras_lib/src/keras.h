#ifndef KERAS_H
#define KERAS_H

#ifdef _WIN32
#ifdef KERASDLL_EXPORTS
#define KERAS_API __declspec(dllexport)
#else //KERASDLL_EXPORTS
#define KERAS_API __declspec(dllimport)
#endif //KERASDLL_EXPORTS
#else //_WIN32
#define KERAS_API
#endif


#if defined(__cplusplus)
extern "C" {
#endif //__cplusplus



#if defined(__cplusplus)
}
#endif /* __cplusplus */

#endif // KERAS_H
