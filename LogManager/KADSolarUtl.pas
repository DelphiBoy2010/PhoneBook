// ***************************************************//
// *               KADSolarUtl                       *//
// *  This is a date unit for all version of Delphi  *//
// *           first version by k.Khojaste           *//
// *           developed by k.Afshar                 *//
// *           publish:2009-2014                     *//
// *           publish:1388-1393                     *//
// *           now version :2.0.0                    *//
// ***************************************************//
(* Change-History *)
// version: 1.1.0 ---Date:88/08/23-2009/11/14
// ADD:function KADg2sDate.it get a date parameter and
// resurn a string.convert geregorian date to solar

// version: 1.2.0 ---Date:88/08/26-2009/11/17
// ADD:function KADSliceDate;
// ADD:function KADSolarValidDate;

// version: 1.3.0 ---Date:88/10/02-2009/12/23
// ADD:function KADNameOfMonth;
// ADD:function KADAddToDate;
// ADD:function KADDiffDate;
// ADD:function KADDateOfWeek;

// version: 2.0.0 ---Date:93/03/20-2014/06/10

// version: 2.0.1 ---Date:93/06/11-2014/09/02
// ADD:function PersianNow;

// version: 2.0.2 ---Date:93/11/01-2015/01/21
//Add: function SolarFullDateIsValid

//1396/01/01
//Add: Change for FMX.
unit KADSolarUtl;

interface

type
  TDateKind = (dkSolar, dkGregorian);

const
  LeapMonth: array [TDateKind] of Byte = (12 { Esfand } , 2 { February } );
  DaysOfMonths: array [TDateKind, 1 .. 12] of Byte =
    ((31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29)
    { Far, Ord, Kho, Tir, Mor, Sha, Meh, Aba, Aza, Day, Bah,^Esf } ,
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    { Jan,^Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec } );
  DaysToMonth: array [TDateKind, 1 .. 13] of Word = ((0, 31, 62, 93, 124, 155,
    186, 216, 246, 276, 306, 336, 365)
    { Far, Ord, Kho, Tir, Mor, Sha, Meh, Aba, Aza, Day, Bah,^Esf, *** } ,
    (0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365)
    { Jan,^Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec, *** } );

  PersianMonthName: array [1 .. 12] of string = ('فروردین', 'اردیبهشت', 'خرداد',
    'تیر', 'مرداد', 'شهریور', 'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند');

  PersianDayName: array [1 .. 7] of string = ('شنبه', 'یکشنبه', 'دوشنبه',
    'سه شنبه', 'چهارشنبه', 'پنج شنبه', 'جمعه');
  EnglishDayName: array [1 .. 7] of string = ('Sunday', 'Monday', 'Tuesday',
    'Wednesday', 'Thursday', 'Friday', 'Saturday');

type
  TSolar = class(TObject)
  private
    FFullPersianDate: string;
    function GetFullPersianDate: string;
    procedure SetFullPersianDate(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    function s2g(dater: string): string;
    function g2s(dater: string): string;

    function IsLeapYear(DateKind: TDateKind; Year: Word): Boolean;
    function DaysOfMonth(DateKind: TDateKind; Year, Month: Word): Word;
    function IsDateValid(DateKind: TDateKind; Year, Month, Day: Word): Boolean;
    function DaysToDate(DateKind: TDateKind; Year, Month, Day: Word): Word;
    function DateOfDay(DateKind: TDateKind; Days, Year: Word;
      var Month, Day: Word): Boolean;
    function GregorianToSolar(var Year, Month, Day: Word): Boolean;
    function SolarToGregorian(var Year, Month, Day: Word): Boolean;

    function SolarEncodeDate(Year, Month, Day: Word): TDateTime;
    procedure SolarDecodeDate(Date: TDateTime; var Year, Month, Day: Word);
    function g2sDate(GDate: TDate): string; overload;
    function g2sDate(GDate: TDateTime): string; overload;
    function s2gDate(SDate: string): TDate;

    function SolarValidDate(SDate: string): Boolean;
    function SolarFullDateIsValid(SDate: string): Boolean;
    function NameOfMonth(SDate: string): string;
    function AddToDate(SDate: string; Value: integer): string;
    function DiffDate(FirstDate, SecondDate: string; var Diff: integer)
      : Boolean;
    function DayOfWeek(SDate: string): string;
    function SliceDate(SDate: string; var y, m, d: Word): Boolean;
    function GetPersianDayName(aDayOfWeek: Integer): string;
    function PersianNow: string;
    function PersianCuurentDate: string;
    class function GetEnglishDayName(aDayOfWeek: Integer): string;
    function MonthFirstDay(aDate: string): string;
    property FullPersianDate: string read GetFullPersianDate;
  end;

var
  SolarDate: TSolar = nil;

implementation

uses
  SysUtils, Variants, Classes;

{ TSolar }
function TSolar.IsLeapYear(DateKind: TDateKind; Year: Word): Boolean;
begin
  if DateKind = dkSolar then
    Result := ((((LongInt(Year) + 38) * 31) mod 128) <= 30)
  else
    Result := ((Year mod 4) = 0) and
      (((Year mod 100) <> 0) or ((Year mod 400) = 0));
end;

function TSolar.MonthFirstDay(aDate: string): string;
begin
  //1394/01/20 => 1934/01/01
  Result := Copy(aDate, 1, 8) + '01';
end;

function TSolar.DaysOfMonth(DateKind: TDateKind; Year, Month: Word): Word;
begin
  if (Year <> 0) and (Month in [1 .. 12]) then
  begin
    Result := DaysOfMonths[DateKind, Month];
    if (Month = LeapMonth[DateKind]) and IsLeapYear(DateKind, Year) then
      Inc(Result);
  end
  else
    Result := 0;
end;

function TSolar.IsDateValid(DateKind: TDateKind;
  Year, Month, Day: Word): Boolean;
begin
  Result := (Year <> 0) and (Month >= 1) and (Month <= 12) and (Day >= 1) and
    (Day <= DaysOfMonth(DateKind, Year, Month));
end;

function TSolar.DaysToDate(DateKind: TDateKind; Year, Month, Day: Word): Word;
begin
  if IsDateValid(DateKind, Year, Month, Day) then
  begin
    Result := DaysToMonth[DateKind, Month] + Day;
    if (Month > LeapMonth[DateKind]) and IsLeapYear(DateKind, Year) then
      Inc(Result);
  end
  else
    Result := 0;
end;

constructor TSolar.Create;
begin

end;

destructor TSolar.Destroy;
begin

  inherited;
end;

function TSolar.DateOfDay(DateKind: TDateKind; Days, Year: Word;
  var Month, Day: Word): Boolean;
var
  LeapDay, m: integer;
begin
  LeapDay := 0;
  Month := 0;
  Day := 0;
  for m := 2 to 13 do
  begin
    if (m > LeapMonth[DateKind]) and IsLeapYear(DateKind, Year) then
      LeapDay := 1;
    if Days <= (DaysToMonth[DateKind, m] + LeapDay) then
    begin
      Month := m - 1;
      if Month <= LeapMonth[DateKind] then
        LeapDay := 0;
      Day := Days - (DaysToMonth[DateKind, Month] + LeapDay);
      Break;
    end;
  end;
  Result := IsDateValid(DateKind, Year, Month, Day);
end;

class function TSolar.GetEnglishDayName(aDayOfWeek: Integer): string;
begin
  Result := EnglishDayName[aDayOfWeek];
end;

function TSolar.GetFullPersianDate: string;
var
  Date: string;
  y1, m1, d1: Word;
begin
  Date := g2sDate(Now);
  SliceDate(Date, y1, m1, d1);
  Result := DayOfWeek(Date) + ' ' + IntToStr(d1) + ' ' +
    NameOfMonth(Date)  + ' ' + IntToStr(y1);
end;

function TSolar.GetPersianDayName(aDayOfWeek: Integer): string;
begin
  Result := PersianDayName[aDayOfWeek];
end;

function TSolar.GregorianToSolar(var Year, Month, Day: Word): Boolean;
var
  LeapDay, Days: integer;
  PrevGregorianLeap: Boolean;
begin
  if IsDateValid(dkGregorian, Year, Month, Day) then
  begin
    PrevGregorianLeap := IsLeapYear(dkGregorian, Year - 1);
    Days := DaysToDate(dkGregorian, Year, Month, Day);
    Dec(Year, 622);
    if IsLeapYear(dkSolar, Year) then
      LeapDay := 1
    else
      LeapDay := 0;
    if PrevGregorianLeap and (LeapDay = 1) then
      Inc(Days, 287)
    else
      Inc(Days, 286);
    if Days > (365 + LeapDay) then
    begin
      Inc(Year);
      Dec(Days, 365 + LeapDay);
    end;
    Result := DateOfDay(dkSolar, Days, Year, Month, Day);
  end
  else
    Result := False;
end;

function TSolar.SolarToGregorian(var Year, Month, Day: Word): Boolean;
var
  LeapDay, Days: integer;
  PrevSolarLeap: Boolean;
begin
  if IsDateValid(dkSolar, Year, Month, Day) then
  begin
    PrevSolarLeap := IsLeapYear(dkSolar, Year - 1);
    Days := DaysToDate(dkSolar, Year, Month, Day);
    Inc(Year, 621);
    if IsLeapYear(dkGregorian, Year) then
      LeapDay := 1
    else
      LeapDay := 0;
    if PrevSolarLeap and (LeapDay = 1) then
      Inc(Days, 80)
    else
      Inc(Days, 79);
    if Days > (365 + LeapDay) then
    begin
      Inc(Year);
      Dec(Days, 365 + LeapDay);
    end;
    Result := DateOfDay(dkGregorian, Days, Year, Month, Day);
  end
  else
    Result := False;
end;

function TSolar.SolarEncodeDate(Year, Month, Day: Word): TDateTime;
begin
  if SolarToGregorian(Year, Month, Day) then
    Result := EncodeDate(Year, Month, Day)
  else
    Result := 0;
end;

function TSolar.SolarFullDateIsValid(SDate: string): Boolean;
begin
  Result := False;
  if (Length(SDate) = 10) then
  begin
    Result := SolarValidDate(SDate);
  end;
end;

procedure TSolar.SolarDecodeDate(Date: TDateTime; var Year, Month, Day: Word);
begin
  DecodeDate(Date, Year, Month, Day);
  GregorianToSolar(Year, Month, Day);
end;

function TSolar.s2g(dater: string): string;
var
  y, m, d: Word;
begin
  y := strtoint(copy(dater, 1, 4));
  m := strtoint(copy(dater, 6, 2));
  d := strtoint(copy(dater, 9, 2));

  // SolarToGregorian(y, m, d);
  // dater := IntToStr(y);
  // if m < 10 then
  // dater := dater + '/0' + IntToStr(m)
  // else
  // dater := dater + '/' + IntToStr(m);
  // if d < 10 then
  // dater := dater + '/0' + IntToStr(d)
  // else
  // dater := dater + '/' + IntToStr(d);
  Result := DateToStr(SolarEncodeDate(y, m, d));
end;

function TSolar.s2gDate(SDate: string): TDate;
var
  y, m, d: Word;
begin
  y := strtoint(copy(SDate, 1, 4));
  m := strtoint(copy(SDate, 6, 2));
  d := strtoint(copy(SDate, 9, 2));

  Result := SolarEncodeDate(y, m, d);
end;

function TSolar.g2s(dater: string): string;
var
  y, m, d: Word;
begin // 1384/01/01
  // y := strtoint(copy(dater, 1, 4));
  // m := strtoint(copy(dater, 6, 2));
  // d := strtoint(copy(dater, 9, 2));
  DecodeDate(StrToDate(dater), y, m, d);
  GregorianToSolar(y, m, d);
  dater := IntToStr(y);
  if m < 10 then
    dater := dater + '/0' + IntToStr(m)
  else
    dater := dater + '/' + IntToStr(m);
  if d < 10 then
    dater := dater + '/0' + IntToStr(d)
  else
    dater := dater + '/' + IntToStr(d);
  Result := dater;
end;

function TSolar.g2sDate(GDate: TDateTime): string;
var
  SDate: string;
  y1, m1, d1: Word;
begin
  DecodeDate(GDate, y1, m1, d1);
  GregorianToSolar(y1, m1, d1);
  SDate := IntToStr(y1);
  if m1 < 10 then
    SDate := SDate + '/0' + IntToStr(m1)
  else
    SDate := SDate + '/' + IntToStr(m1);
  if d1 < 10 then
    SDate := SDate + '/0' + IntToStr(d1)
  else
    SDate := SDate + '/' + IntToStr(d1);
  Result := SDate;

end;

procedure TSolar.SetFullPersianDate(const Value: string);
begin
  FFullPersianDate := Value;
end;

function TSolar.SliceDate(SDate: string; var y, m, d: Word): Boolean;
begin
  try
    y := StrToIntDef(copy(SDate, 1, 4), 0);
    m := StrToIntDef(copy(SDate, 6, 2), 0);
    d := StrToIntDef(copy(SDate, 9, 2), 0);
    Result := True;
  Except
    Result := False;
  end; // except
end;

function TSolar.AddToDate(SDate: string; Value: integer): string;
var
  VTempDate, VNewDate: TDate;
  VGDate: string;
begin
  if SolarValidDate(SDate) then // if 1
  begin
    VGDate := s2g(SDate);
    VTempDate := StrToDate(VGDate);
    VNewDate := VTempDate + Value;
    Result := g2sDate(VNewDate);
  end
  else
  begin
    Result := '';
  end; // if 1
end;

function TSolar.DayOfWeek(SDate: string): string;
var
  VDiff: integer;
begin
  if DiffDate('1388/01/01', SDate, VDiff) then
  begin
    if VDiff >= 0 then
    begin
      VDiff := VDiff Mod 7;
      if VDiff = 0 then
        VDiff := 7; // For last day of week

      Result := PersianDayName[VDiff];
      // case VDiff of
      // 0:
      // Result :=  'جمعه';
      // 1:
      // Result := 'شنبه';
      // 2:
      // Result := 'یکشنبه';
      // 3:
      // Result := 'دوشنبه';
      // 4:
      // Result := 'سه شنبه';
      // 5:
      // Result := 'چهارشنبه';
      // 6:
      // Result := 'پنج شنبه';
      // end;
    end
    else
    begin
      VDiff := VDiff Mod 7;
      case VDiff of
        0:
          Result := PersianDayName[2]; // 'یکشنبه';
        -1:
          Result := PersianDayName[1]; // 'شنبه';
      else
        begin
          Result := PersianDayName[VDiff + 9];
        end;
        // -2:
        // Result := 'جمعه';
        // -3:
        // Result := 'پنج شنبه';
        // -4:
        // Result := 'چهارشنبه';
        // -5:
        // Result := 'سه شنبه';
        // -6:
        // Result := 'دوشنبه';
      end;
    end;
  end
  else
  begin
    Result := '';
  end;

end;

function TSolar.DiffDate(FirstDate, SecondDate: string;
  var Diff: integer): Boolean;
var
  VFirstDate, VSecondDate: TDate;
  VNewDate: Variant;
begin
  if SolarValidDate(FirstDate) AND SolarValidDate(SecondDate) then
  begin
    // VFirstDate := StrToDate(s2g(FirstDate), FormatSettings);
    VFirstDate := s2gDate(FirstDate);
    // VSecondDate := StrToDate(s2g(SecondDate), FormatSettings);
    VSecondDate := s2gDate(SecondDate);
    VNewDate := VSecondDate - VFirstDate;
    Diff := VNewDate;
    if Diff >= 0 then
      Inc(Diff)
    else
      Dec(Diff);
    Result := true;
  end
  else
  begin
    Result := False;
  end;
end;

function TSolar.g2sDate(GDate: TDate): string;
var
  SDate: string;
  y1, m1, d1: Word;
begin
  DecodeDate(GDate, y1, m1, d1);
  GregorianToSolar(y1, m1, d1);
  SDate := IntToStr(y1);
  if m1 < 10 then
    SDate := SDate + '/0' + IntToStr(m1)
  else
    SDate := SDate + '/' + IntToStr(m1);
  if d1 < 10 then
    SDate := SDate + '/0' + IntToStr(d1)
  else
    SDate := SDate + '/' + IntToStr(d1);
  Result := SDate;
end;

function TSolar.NameOfMonth(SDate: string): string;
var
  y1, m1, d1: Word;
begin
  if SolarValidDate(SDate) then // if 1
  begin
    if SliceDate(SDate, y1, m1, d1) then // if 2
    begin
      Result := PersianMonthName[m1];
      // case m1 of
      //
      // 1:
      // Result := 'فروردین';
      // 2:
      // Result := 'اردیبهشت';
      // 3:
      // Result := 'خرداد';
      // 4:
      // Result := 'تیر';
      // 5:
      // Result := 'مرداد';
      // 6:
      // Result := 'شهریور';
      // 7:
      // Result := 'مهر';
      // 8:
      // Result := 'آبان';
      // 9:
      // Result := 'آذر';
      // 10:
      // Result := 'دی';
      // 11:
      // Result := 'بهمن';
      // 12:
      // Result := 'اسفند';
      // end;
    end
    else
    begin
      Result := '';
    end;
  end
  else
  begin
    Result := '';
  end;
end;

function TSolar.PersianCuurentDate: string;
begin
  Result := g2sDate(Now);
end;

function TSolar.PersianNow: string;
begin
  Result := g2sDate(Now) + ' ' + TimeToStr(Now);
end;

function TSolar.SolarValidDate(SDate: string): Boolean;
var
  y1, m1, d1: Word;
begin
  Result := False;
  if SliceDate(SDate, y1, m1, d1) then
  begin
    if IsDateValid(dkSolar, y1, m1, d1) then
    begin
      Result := True
    end;
  end;
end;

end.
