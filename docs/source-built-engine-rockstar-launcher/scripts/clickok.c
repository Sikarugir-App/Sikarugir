#include <windows.h>
static HANDLE out; static void say(const char *s){ DWORD n; WriteFile(out,s,lstrlenA(s),&n,0); }
static BOOL CALLBACK find_ok(HWND h, LPARAM l){ char t[64]; GetWindowTextA(h,t,sizeof t); if(!lstrcmpA(t,"OK")){ *(HWND*)l=h; return FALSE;} return TRUE; }
void __stdcall start(void){ HWND dlg, ok=0; out=GetStdHandle(STD_OUTPUT_HANDLE);
  dlg=FindWindowA("#32770","Minimum Recommended Hardware Check Failure\n"); if(!dlg) dlg=FindWindowA("#32770","Minimum Recommended Hardware Check Failure");
  if(!dlg){ say("Dialog nicht gefunden\r\n"); ExitProcess(1);} EnumChildWindows(dlg,find_ok,(LPARAM)&ok);
  if(!ok){ say("OK-Knopf nicht gefunden\r\n"); ExitProcess(2);} PostMessageA(dlg,WM_COMMAND,MAKEWPARAM(GetDlgCtrlID(ok),BN_CLICKED),(LPARAM)ok); say("OK geklickt\r\n"); ExitProcess(0); }
