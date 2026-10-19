#include <windows.h>
static HANDLE out;
static void say(const char *s){ DWORD n; WriteFile(out,s,lstrlenA(s),&n,0); }
static BOOL CALLBACK child(HWND h, LPARAM l){ char c[128], t[512], b[800]; GetClassNameA(h,c,sizeof c); GetWindowTextA(h,t,sizeof t); if(t[0]){ wsprintfA(b,"    child [%s] \"%s\"\r\n",c,t); say(b);} return TRUE; }
static BOOL CALLBACK top(HWND h, LPARAM l){ DWORD pid; char c[128], t[512], exe[MAX_PATH]="?", b[1000]; RECT r; HANDLE p; DWORD n=sizeof exe; char *e;
  if(!IsWindowVisible(h)) return TRUE;
  GetWindowThreadProcessId(h,&pid); p=OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION,FALSE,pid);
  if(p){ QueryFullProcessImageNameA(p,0,exe,&n); CloseHandle(p);} e=exe; for(char *q=exe;*q;q++) if(*q=='\\') e=q+1;
  GetClassNameA(h,c,sizeof c); GetWindowTextA(h,t,sizeof t); GetWindowRect(h,&r);
  wsprintfA(b,"%s pid=%lu [%s] \"%s\" %ldx%ld\r\n", e, pid, c, t, r.right-r.left, r.bottom-r.top); say(b);
  EnumChildWindows(h,child,0); return TRUE; }
void __stdcall start(void){ out=GetStdHandle(STD_OUTPUT_HANDLE); EnumWindows(top,0); ExitProcess(0); }
