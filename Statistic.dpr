library Statistic;

uses Windows, Messages;

var
  SysHook: HHook = 0;
  Wnd: Hwnd = 0;

function SysMsgProc(code: integer; wParam: word;
  lParam: longint): longint; stdcall;
begin
 // Передать сообщение другим ловушкам в системе
 CallNextHookEx(SysHook, Code, wParam, lParam);
 // Проверяю сообщение
 if code = HC_ACTION
 then
  begin
   // Проверяю тип сообщения
   // Если нажата клавиша на клавиатуре
   if TMsg(Pointer(lParam)^).message = WM_KEYUP
   then
    begin
     Wnd := FindWindow('T_KeyStat', nil);
     SendMessage(Wnd, WM_KEYUP, TMsg(Pointer(lParam)^).wParam, 0);
    end;
   // Нажата левая кнопка мыши
   if TMsg(Pointer(lParam)^).message = WM_LBUTTONUP
   then
    begin
     Wnd := FindWindow('T_KeyStat', nil);
     SendMessage(Wnd, WM_LBUTTONUP, 0, 0);
    end;
   // Нажата правая кнопка мыши
   if TMsg(Pointer(lParam)^).message = WM_RBUTTONUP
   then
    begin
     Wnd := FindWindow('T_KeyStat', nil);
     SendMessage(Wnd, WM_RBUTTONUP, 0, 0);
    end;
   // Нажата средняя кнопка мыши
   if TMsg(Pointer(lParam)^).message = WM_MBUTTONUP
   then
    begin
     Wnd := FindWindow('T_KeyStat', nil);
     SendMessage(Wnd, WM_MBUTTONUP, 0, 0);
    end;
  end;
end;

// Процедура запуска.

procedure RunStopHook(State: Boolean) export; stdcall;
begin
  //Если State = true, то ...
  if State = true then
  begin
    //Запускаем ловушку
    SysHook := SetWindowsHookEx(WH_GETMESSAGE,
      @SysMsgProc, HInstance, 0);
  end
  else //Иначе
  begin
    //Отключить ловушку
    UnhookWindowsHookEx(SysHook);
    SysHook := 0;
  end;
end;

exports RunStopHook index 1;

begin
end.

