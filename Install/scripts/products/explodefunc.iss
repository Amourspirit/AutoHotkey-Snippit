type
TStringArray = array of string;
 function Explode(delimiter:string; str:string; limit:integer):TStringArray;
 var
   p,cc,dsize:integer;
 begin
   cc := 0;
   dsize := length(delimiter);
   if dsize = 0 then
   begin
     setlength(result,1);
     result[0] := str;
     exit;
   end;
   while cc+1 < limit do
   begin
     p := pos(delimiter,str);
     if p > 0 then
     begin
       inc(cc);
       setlength(result,cc);
       result[cc-1] := copy(str,1,p-1);
       delete(str,1,p+dsize-1);
     end else break;
   end;
   inc(cc);
   setlength(result,cc);
   result[cc-1] := str;
 end;