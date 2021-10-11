program KeyStatistic;

uses Windows, Messages;


// ���������� ���������� �� �������� ������ ��������� � dll'��
procedure RunStopHook(State: Boolean); stdcall;
  external 'Statistic.dll' index 1;



const
  MaxPress = 10; // ���������� �������, ����� �������� ���������� ����������
var
  // ������� ����������
  Instanse: HWND;
  WindowClass: TWndClass;
  Handle: HWND;
  Msg: TMsg;
  CurStr, CurCodeStr, PressCountStr: string;
  CurCode, PressCount: Integer;


  // ����������� ����������
  IntArray: array[1..255] of Integer;
  //������ ����� ����� (���-�� ������� �� ������ �������)
  Keys: array[1..255] of string[20]; // ������ �������� ������
  Counter: Integer = 0; // ������� �������
  Sum: Integer = 0; // ����� ���� ������� (�������������� ��� ��������)
  I, J: Integer; // �������� ������
  FP: TextFile;


// ��������� �� ���������� ������ SysUtils, �� ����� ���� �������
function StrToInt(STR1: string): Integer;
var Int1, Code: Integer;
begin
  Val(STR1, Int1, Code);
  Result := Int1;
end;

function IntToStr(INT1: Integer): string;
begin
  Str(INT1, Result);
end;

// ��������� ������ �� ���������
procedure DoExit;
begin
  RunStopHook(false);
  Halt;
end;

procedure CreateTxtFile(FileName: string);
var
  FP: TextFile;
begin
  AssignFile(FP, FileName);
  Rewrite(FP);
  Write(FP);
  CloseFile(FP);
end;

procedure SaveKeysToFile;
var
  FP: TextFile;
  I: Integer;
  Str1: string;
begin
  // ����� ���� ������� �������� � Sum
  AssignFile(FP, 'KeysStore.txt');
  Rewrite(FP);
  WriteLn(FP, '����� ������������� �������: ' + IntToStr(Sum));
  // ���������� ��������� ������
  for I := 1 to 255 do
  begin
    Str1 := IntToStr(I) + '   ' + Keys[I];
    if IntArray[I] > 0 then Insert(IntToStr(IntArray[I]), Str1, Length(Str1) + 1)
    else Continue;
    WriteLn(FP, Str1);
  end; //for
  CloseFile(FP);
end;

// ���������� �������
function WindowProc(Hwn, Msg, Wpr, Lpr: Longint): Longint; stdcall;
begin
  Result := DefWindowProc(Hwn, Msg, Wpr, Lpr);
  if Msg = WM_DESTROY then DoExit;

  if (Msg = WM_KEYUP) then
  begin
    Inc(Counter);
    Inc(Sum);
    Inc(IntArray[Wpr]);
    if (Counter / MaxPress) = (Counter div MaxPress) then
      SaveKeysToFile;
  end;
  if (Msg = WM_LButtonUp) then
  begin
    Inc(Counter);
    Inc(Sum);
    Inc(IntArray[1]);
    if (Counter / MaxPress) = (Counter div MaxPress) then
      SaveKeysToFile;
  end;
  if (Msg = WM_RButtonUp) then
  begin
    Inc(Counter);
    Inc(Sum);
    Inc(IntArray[2]);
    if (Counter / MaxPress) = (Counter div MaxPress) then
      SaveKeysToFile;
  end;
  if (Msg = WM_MButtonUp) then
  begin
    Inc(Counter);
    Inc(Sum);
    Inc(IntArray[3]);
    if (Counter / MaxPress) = (Counter div MaxPress) then
      SaveKeysToFile;
  end;
end;



// ����� ����� � ���������
begin
  Sum := 0;
  Instanse := GetModuleHandle(nil);
  with WindowClass do
  begin
    style := CS_HREdraw or CS_VRedraw;
    lpfnWndProc := @WindowProc;
    hInstance := Instanse;
    hbrBackground := color_btnface;
    lpszClassName := 'T_KeyStat';
    hCursor := LoadCursor(0, IDC_ARROW);
  end;

  // ������������ ����� �����
  RegisterClass(WindowClass);

  // ������� ����
  Handle := CreateWindowEx(0, 'T_KeyStat', '', WS_TILEDWINDOW, cw_UseDefault,
    cw_UseDefault, cw_UseDefault, cw_UseDefault, 0, 0, Instanse, nil);

  // ���� ���������� ��� ������� OnCreate
  RunStopHook(true);
  // ��������� �������
  for I := 1 to 255 do
    IntArray[I] := 0; // �������������� �������, ��� ������� �� ����
  for I := 1 to 255 do Keys[I] := 'NONAME  :'; // ��������� �����������

  // ��������� �����
  for I := 65 to 90 do Keys[I] := 'Key ' + Chr(I) + ': ';

  // ��������� ������� F1 - F10
  Keys[112] := 'Key F1: ';
  Keys[113] := 'Key F2: ';
  Keys[114] := 'Key F3: ';
  Keys[115] := 'Key F4: ';
  Keys[116] := 'Key F5: ';
  Keys[117] := 'Key F6: ';
  Keys[118] := 'Key F7: ';
  Keys[119] := 'Key F8: ';
  Keys[120] := 'Key F9: ';
  Keys[121] := 'Key F10: ';
  Keys[122] := 'Key F11: ';
  Keys[123] := 'Key F12: ';

  // ��������� �������� �����
  for I := 48 to 57 do Keys[I] := 'Key ' + Chr(I) + ': ';

  // ��������� �������������� �����
  Keys[96] := 'Num 0: ';
  Keys[97] := 'Num 1: ';
  Keys[98] := 'Num 2: ';
  Keys[99] := 'Num 3: ';
  Keys[100] := 'Num 4: ';
  Keys[101] := 'Num 5: ';
  Keys[102] := 'Num 6: ';
  Keys[103] := 'Num 7: ';
  Keys[104] := 'Num 8: ';
  Keys[105] := 'Num 9: ';

  // ��������� ��������� �����
  Keys[219] := 'Key [: ';
  Keys[221] := 'Key ]: ';
  Keys[186] := 'Key ;: ';
  Keys[222] := 'Key '': ';
  Keys[188] := 'Key <: ';
  Keys[190] := 'Key >: ';
  Keys[191] := 'Key /: ';
  Keys[192] := 'Key �: ';
  Keys[189] := 'Key -: ';
  Keys[187] := 'Key =: ';
  Keys[220] := 'Key \: ';
  Keys[8] := 'BackSpace: ';
  Keys[13] := 'Enter: ';
  Keys[16] := 'Shift: ';
  Keys[17] := 'Control: ';
  Keys[91] := 'L_Window: ';
  Keys[92] := 'R_Window: ';
  Keys[32] := 'Space: ';
  Keys[93] := 'Menu: ';
  Keys[27] := 'Escape: ';
  Keys[9] := 'Tab: ';
  Keys[20] := 'CapsLock: ';
  Keys[145] := 'ScrollLock: ';
  Keys[19] := 'Pause: ';
  Keys[45] := 'Insert: ';
  Keys[36] := 'Home: ';
  Keys[33] := 'PageUp: ';
  Keys[46] := 'Delete: ';
  Keys[35] := 'End: ';
  Keys[34] := 'PageDown: ';
  Keys[144] := 'NumLock: ';
  Keys[38] := 'Forward: ';
  Keys[39] := 'Rigth: ';
  Keys[40] := 'Back: ';
  Keys[37] := 'Left: ';
  Keys[111] := 'Num /: ';
  Keys[106] := 'Num *: ';
  Keys[109] := 'Num -: ';
  Keys[107] := 'Num +: ';
  Keys[110] := 'Num .: ';

  // ���� ��� �����
  Keys[1] := 'LButton: ';
  Keys[2] := 'RButton: ';
  Keys[3] := 'MButton: ';

  // �������� ����� ����� �� 20
  for I := 1 to 255 do
  begin
    while Length(Keys[I]) < 20 do
      Insert(' ', Keys[I], Length(Keys[I]) + 1);
  end;

  // ��������� ������ �� �����, ���� �� ����������
  // ���������, ���� �� ���� �� �����
  AssignFile(FP, 'KeysStore.txt');
{$I-}
  Reset(FP);
{$I+}
  if IOResult = 0 then // ���� ����������, ��������� �� ���� ������
  begin
    while not EOF(FP) do
    begin
      CurCodeStr := '';
      PressCountStr := '';
      CurCode := 0;
      PressCount := 0;
      ReadLn(FP, CurStr); // ��������� ��������� ������
      if (Length(CurStr) > 0) and ((CurStr[1] < '0') or (CurStr[1] > '9')) then
        Continue;
      if (Length(CurStr) = 0) then Continue;

      // ��������� ��� �������
      for I := 1 to Length(CurStr) do
      begin
        if (CurStr[I] < '0') or (CurStr[I] > '9') then Break;
        Insert(CurStr[I], CurCodeStr, Length(CurCodeStr) + 1);
      end;
      if Length(CurCodeStr) = 0 then Continue;
      try
        CurCode := StrToInt(CurCodeStr);
      except
      end;
      if (CurCode = 0) or (CurCode > 255) then Continue;

      // ���� ���������� �������
      for I := 1 to Length(CurStr) do
      begin
        if CurStr[I] = ':' then
        begin
          for J := I + 1 to Length(CurStr) do
          begin
            if (Length(PressCountStr) > 0) and
              ((CurStr[J] < '0') or (CurStr[J] > '9')) then Break; // ����� ����

            if ((CurStr[J] >= '0') and (CurStr[J] <= '9')) then
              Insert(CurStr[J], PressCountStr, Length(PressCountStr) + 1);
          end; //for  J
          break; // ����� ������������
        end; //if
      end; //for I

      // �������� ���������� �������
      if Length(PressCountStr) = 0 then Continue;
      try
        PressCount := StrToInt(PressCountStr);
      except
      end;
      if PressCount = 0 then Continue;

      // ��������� ������ � ������
      IntArray[CurCode] := PressCount;


    end; // while

    CloseFile(FP);
  end; // if

  for I := 1 to 255 do
    Inc(Sum, IntArray[I]);

  // ���� ��������� ���������
  while GetMessage(Msg, 0, 0, 0) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end.

