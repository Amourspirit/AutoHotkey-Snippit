[CustomMessages]
mfsize_size=12 MB - 15 MB

[Code]
var
  mf_url: string;
  mf_title: string;
  mf_product: string;


procedure miniframwork(Version: MfVersions);
begin
  case Version of
    v0200:
    if (not mfinstalled(v0200)) then begin
      mf_url := miniframwork0200url;
      mf_title := 'Mini-Framwork 0.2.0'
      mf_product := 'MfSetup.exe';

      AddProduct(
        mf_product,
        ' /SILENT /SP',        
        mf_title,
        CustomMessage('mfsize_size'),        
        mf_url,
        false, false);
    end;
  end;
end;

procedure miniframework(Version: string);
var
  sMajorMinor: string;
begin
  sMajorMinor := VersionGetParts(Version, true, false, false);
  if (not mfVerInstalled(Version)) then
  begin
      if (sMajorMinor = '0.3') then
      begin
          mf_url := miniframwork03xurl;
          mf_title := 'Mini-Framwork ' + Version;
      end;
      if (sMajorMinor = '0.4') then
      begin
          mf_url := miniframwork04xurl;
          mf_title := 'Mini-Framwork ' + Version;
      end;
      mf_product := 'MfSetup.exe';
      AddProduct(
        mf_product,
        ' /SILENT /SP',        
        mf_title,
        CustomMessage('mfsize_size'),        
        mf_url,
        false, false);
  end;
end;