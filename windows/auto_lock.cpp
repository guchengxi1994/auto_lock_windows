#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
#define IS_WIN32
#endif

#ifdef __ANDROID__
#include <android/log.h>
#endif

#ifdef IS_WIN32
#include <windows.h>
#endif

#define MONITOR_ON -1
#define MONITOR_OFF 2
#define MONITOR_STANBY 1

#if defined(__GNUC__)
// Attributes to prevent 'unused' function from being removed and to make it visible
#define FUNCTION_ATTRIBUTE __attribute__((visibility("default"))) __attribute__((used))
#elif defined(_MSC_VER)
// Marking a function for export
#define FUNCTION_ATTRIBUTE __declspec(dllexport)
#endif

extern "C"
{
    FUNCTION_ATTRIBUTE
    void lock_screen()
    {
        LockWorkStation();
    }

    FUNCTION_ATTRIBUTE
    void sleep_windows()
    {
        PostMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, MONITOR_OFF);
    }

    FUNCTION_ATTRIBUTE
    int get_last_input_duration(){
        LASTINPUTINFO LastInput = {};
        LastInput.cbSize = sizeof(LastInput);
        GetLastInputInfo(&LastInput);
        int idleTime = (GetTickCount() - LastInput.dwTime) / 1000;
        return idleTime;
    }
}