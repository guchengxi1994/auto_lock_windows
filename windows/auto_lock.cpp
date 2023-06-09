#include <iostream>

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
#define IS_WIN32
#endif

#ifdef __ANDROID__
#include <android/log.h>
#endif

#ifdef IS_WIN32
#include <windows.h>
#include <WtsApi32.h>
#pragma comment(lib, "wtsapi32.lib")
#pragma comment(lib, "winmm")
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

inline bool file_exists(const std::string &name)
{
    struct stat buffer;
    return (stat(name.c_str(), &buffer) == 0);
}

bool is_session_locked()
{
    WTSINFOEXW *pInfo = NULL;
    WTS_INFO_CLASS wtsic = WTSSessionInfoEx;
    LPTSTR ppBuffer = NULL;
    DWORD dwBytesReturned = 0;
    LONG sessionFlags = WTS_SESSIONSTATE_UNKNOWN; // until we know otherwise. Prevents a false positive since WTS_SESSIONSTATE_LOCK == 0

    DWORD dwSessionID = WTSGetActiveConsoleSessionId();

    if (WTSQuerySessionInformation(WTS_CURRENT_SERVER_HANDLE, dwSessionID, wtsic, &ppBuffer, &dwBytesReturned))
    {
        if (dwBytesReturned > 0)
        {
            pInfo = (WTSINFOEXW *)ppBuffer;
            if (pInfo->Level == 1)
            {
                sessionFlags = pInfo->Data.WTSInfoExLevel1.SessionFlags;
            }
        }
        WTSFreeMemory(ppBuffer);
        ppBuffer = NULL;
    }

    return (sessionFlags == WTS_SESSIONSTATE_LOCK);
}

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
    int get_last_input_duration()
    {
        if (is_session_locked())
        {
            std::cout << "[c++] windows locked" << std::endl;
            return 0;
        }

        LASTINPUTINFO LastInput = {};
        LastInput.cbSize = sizeof(LastInput);
        GetLastInputInfo(&LastInput);
        int idleTime = (GetTickCount() - LastInput.dwTime) / 1000;
        return idleTime;
    }

    FUNCTION_ATTRIBUTE
    void play_sound()
    {
        if (file_exists("C:/Windows/Media/Alarm01.wav"))
        {
            PlaySound(TEXT("C:/Windows/Media/Alarm01.wav"), NULL, SND_ASYNC);
        }
    }
}