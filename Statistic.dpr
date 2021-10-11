library Statistic;

uses Windows, Messages;

var
  SysHook: HHook = 0;
  Wnd: Hwnd = 0;

function SysMsgProc(code: integer; wParam: word;
  lParam: longint): longint; stdcall;
begin
 // �������� ��������� ������ �������� � �������
 CallNextHookEx(SysHook, Code, wParam, lParam);
 // �������� ���������
 if code = HC_ACTION
 then
  begin
   // �������� ��� ���������
   // ���� ������ ������� �� ����������
   if TMsg(Pointer(lParam)^).message = WM_KEYUP
   then
    begin
     Wnd := FindWindow('T_KeyStat', nil);
     SendMessage(Wnd, WM_KEYUP, TMsg(Pointer(lParam)^).wParam, 0);
    end;
   // ������ ����� ������ ����
   if TMsg(Pointer(lParam)^).message = WM_LBUTTONUP
   then
    begin
     Wnd := FindWindow('T_KeyStat', nil);
     SendMessage(Wnd, WM_LBUTTONUP, 0, 0);
    end;
   // ������ ������ ������ ����
   if TMsg(Pointer(lParam)^).message = WM_RBUTTONUP
   then
    begin
     Wnd := FindWindow('T_KeyStat', nil);
     SendMessage(Wnd, WM_RBUTTONUP, 0, 0);
    end;
   // ������ ������� ������ ����
   if TMsg(Pointer(lParam)^).message = WM_MBUTTONUP
   then
    begin
     Wnd := FindWindow('T_KeyStat', nil);
     SendMessage(Wnd, WM_MBUTTONUP, 0, 0);
    end;
  end;
end;

// ��������� �������.

procedure RunStopHook(State: Boolean) export; stdcall;
begin
  //���� State = true, �� ...
  if State = true then
  begin
    //��������� �������
    SysHook := SetWindowsHookEx(WH_GETMESSAGE,
      @SysMsgProc, HInstance, 0);
  end
  else //�����
  begin
    //��������� �������
    UnhookWindowsHookEx(SysHook);
    SysHook := 0;
  end;
end;

exports RunStopHook index 1;

begin
end.

