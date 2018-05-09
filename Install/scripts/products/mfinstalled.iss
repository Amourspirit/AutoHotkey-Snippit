

[Code]
const
	miniframwork0200url = 'http://bigbytetech.ca/files/Software/mini-framwork/0200/MfSetup.exe';
  miniframwork03xurl = 'http://github.com/Amourspirit/Mini-Framework/raw/master/Latest/stable/0.3x/MfSetup.exe';
  miniframwork04xurl = 'http://github.com/Amourspirit/Mini-Framework/raw/master/Latest/stable/0.4x/MfSetup.exe';
  mfsoftwarekey_reg = 'software\Mini-Framework\';
  type
    MfVersions = (v0200);

function mfinstalled(MfVersion: MfVersions): boolean;
var
  MyResult: boolean;
begin
    MyResult := False;
    case MfVersion of            
      v0200:
        if RegKeyExists(HKLM, mfsoftwarekey_reg + '0.2.0') then
        begin
          MyResult := True;
        end;
    end;

    Result := MyResult;
end;

function mfVerInstalled(MinVersion: string): boolean;
var
  MyResult: boolean;
  version, sMajorMinor, sQuery: string;
begin
    MyResult := False;
    // get the Major and Minor as string such as '2.1'
    sMajorMinor := VersionGetParts(MinVersion, true, false, false);
    sQuery := mfsoftwarekey_reg +  sMajorMinor;
    if RegQueryStringValue(HKLM, sQuery, 'Version', version) then
    begin
    if (compareStringVersions(MinVersion, version) > 0) then
      begin
        MyResult := False;
      end
      else
      begin
        MyResult := True;
      end
    end;
    Result := MyResult;
end;