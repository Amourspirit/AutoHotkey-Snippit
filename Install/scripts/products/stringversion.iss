// Written by Paul M
// Date Created Jan 29, 2017
// requires include explodefunc.iss
// explodefunc.iss must be included before this file
function VersionGetParts(ver:string; minor:boolean; build:boolean; rev:boolean): string;
var
   str: String;
   sMajor,sMinor,sBuild,sRevision: string;
   aSplit:TStringArray;
   i, iLength: Integer;
begin
    sMajor := '0';
    sMinor := '0';
    sBuild := '0';
    sRevision := '0';
    aSplit := Explode('.', ver, 10);
     iLength := HIGH(aSplit);
     For i := 0 to iLength do
     begin
        case i of
             0:sMajor :=  aSplit[i];
             1:sMinor :=  aSplit[i];
             2:sBuild :=  aSplit[i];
             3:sRevision :=  aSplit[i];
        end;
     end;
     str := sMajor;
     if minor = true then
     begin
             str := str + '.' + sMinor;
     end;
     if build = true then
     begin
             str := str + '.' + sBuild;
     end;
     if rev = true then
     begin
             str := str + '.' + sRevision;
     end;
     result := str;
end;  

// Written by Paul M
// Date Created Feb 14, 2017
// requires include explodefunc.iss
// explodefunc.iss must be included before this file
// Compares tow string in #.#.# format
// there is not limit to the numbe of placeholder allowed.
function compareStringVersions(v1:string; v2:string) : integer;
var
   v1parts : TStringArray;
   v2parts : TStringArray;
   v1Count, v2Count, i: integer;

begin
   v1parts := Explode('.', v1, 10);
   v2parts := Explode('.', v2, 10);
   v1Count := HIGH(v1parts);
   v2Count := HIGH(v2parts);
   For i := 0 to v1Count do
   begin
        if (v2Count < i) then
        begin
            result := 1;
            exit;
        end;
       if (v1parts[i] = v2parts[i]) then
       begin
           continue;
       end;
       if (v1parts[i] > v2parts[i]) then
       begin
           result := 1;
           exit;
       end
       else
       begin
           result := -1;
           exit;
       end;
   end;
   if (v1Count <> v2Count) then
   begin
      result := -1;
      exit;
   end;
   result := 0;
   exit;
end;

function stringtoversion(var temp: String): Integer;
var
	part: String;
	pos1: Integer;

begin
	if (Length(temp) = 0) then begin
		Result := -1;
		Exit;
	end;

	pos1 := Pos('.', temp);
	if (pos1 = 0) then begin
		Result := StrToInt(temp);
		temp := '';
	end else begin
		part := Copy(temp, 1, pos1 - 1);
		temp := Copy(temp, pos1 + 1, Length(temp));
		Result := StrToInt(part);
	end;
end;

function compareinnerversion(var x, y: String): Integer;
var
	num1, num2: Integer;

begin
	num1 := stringtoversion(x);
	num2 := stringtoversion(y);
	if (num1 = -1) and (num2 = -1) then begin
		Result := 0;
		Exit;
	end;

	if (num1 < 0) then begin
		num1 := 0;
	end;
	if (num2 < 0) then begin
		num2 := 0;
	end;

	if (num1 < num2) then begin
		Result := -1;
	end else if (num1 > num2) then begin
		Result := 1;
	end else begin
		Result := compareinnerversion(x, y);
	end;
end;

function compareversion(versionA, versionB: String): Integer;
var
  temp1, temp2: String;

begin
    temp1 := versionA;
    temp2 := versionB;
    Result := compareinnerversion(temp1, temp2);
end;